part of z.flutter.cache;

///
@Deprecated('This will be removed in a future version')
abstract class BasePersistedCache<T> {
  BasePersistedCache() {
    load();
  }

  final _subject = BehaviorSubject<T>();

  /// The current stream of [data] elements.
  Stream<T> get stream => _subject.stream;

  /// The current [data].
  T get data => _subject.value;

  @protected
  Future<T> onLoad();

  @protected
  Future<void> onSave(T data);

  ///
  Future<void> load() {
    return onLoad().then((value) => _subject.add(value));
  }

  ///
  Future<void> save(T data) {
    return onSave(data).then((_) => _subject.add(data));
  }

  /// Closes the instance.
  /// This method should be called when the instance is no longer needed.
  /// Once [close] is called, the instance can no longer be used.
  void close() => _subject.close();
}

///
@Deprecated('This will be removed in a future version')
class PersistedCache<T> extends BasePersistedCache<T> {
  PersistedCache(
    this.name,
    this.jsonMapper,
    this.dfltData,
  ) : super();

  final String name;
  final JsonMapper<T> jsonMapper;
  final T dfltData;

  @override
  Future<T> onLoad() {
    return SharedPreferences.getInstance().then((prefs) {
      final jsonRaw = prefs.getString(name);
      final jsonObj = jsonRaw?.let((it) => jsonDecode(it));
      return jsonObj?.let((it) => jsonMapper.fromJson(it)) ?? dfltData;
    });
  }

  @override
  Future<void> onSave(T data) async {
    return SharedPreferences.getInstance().then((prefs) {
      final jsonObj = jsonMapper.toJson(data);
      final jsonRaw = jsonEncode(jsonObj);
      prefs.setString(name, jsonRaw);
    });
  }
}

///
@Deprecated('This will be removed in a future version')
class PersistedCollectionCache<T> extends BasePersistedCache<Map<String, T>> {
  PersistedCollectionCache(
    this.name,
    this.jsonMapper,
    this.dfltData,
  ) : super();

  final String name;
  final JsonMapper<T> jsonMapper;
  final Map<String, T> dfltData;

  @override
  Future<Map<String, T>> onLoad() async {
    return SharedPreferences.getInstance().then((prefs) {
      final jsonRaw = prefs.getString(name);
      final Map<String, dynamic>? jsonObj =
          jsonRaw?.let((it) => jsonDecode(it));
      return jsonObj?.map(
            (key, value) => MapEntry(key, jsonMapper.fromJson(value)),
          ) ??
          dfltData;
    });
  }

  @override
  Future<void> onSave(Map<String, T> data) {
    return SharedPreferences.getInstance().then((prefs) {
      final Map<String, dynamic> jsonObj = data.map(
        (key, value) => MapEntry(key, jsonMapper.toJson(value)),
      );
      final jsonRaw = jsonEncode(jsonObj);
      prefs.setString(name, jsonRaw);
    });
  }
}

///
extension PersistedCollectionExt<T> on BasePersistedCache<Map<String, T>> {
  Stream<List<T>> get values => stream.map((event) => event.values.toList());

  Stream<List<T>> valuesWhere(bool Function(T value) test) {
    return values.map((event) => event.where(test).toList());
  }

  Stream<T?> valueOrNull(String key) {
    return stream.map((event) => event[key]);
  }

  Stream<T> valueOrElse(String key, {required T Function() orElse}) {
    return valueOrNull(key).map((event) => event ?? orElse());
  }

  bool contains(String key) {
    return data.containsKey(key);
  }

  Future<void> update(void Function(Map<String, T> data) block) {
    return save(Map.of(data).also(block));
  }

  Future<void> put(String key, T value) {
    return update((data) => data[key] = value);
  }

  @Deprecated('Use put instead. This will be removed in a future version')
  Future<void> add(String key, T value) {
    return put(key, value);
  }

  Future<void> addAll(Map<String, T> other) {
    return update((data) => data.addAll(other));
  }

  Future<void> replaceAll(Map<String, T> other) {
    return save(Map.of(other));
  }

  Future<void> remove(String key) {
    return update((data) => data.remove(key));
  }

  Future<void> removeWhere(bool Function(String key, T value) test) {
    return update((data) => data.removeWhere(test));
  }

  Future<void> clear() {
    return save({});
  }
}

///
extension IdentifiableCollectionCacheExt<T extends Identifiable>
    on BasePersistedCache<Map<String, T>> {
  bool containsObject(T object) {
    return contains(object.id.toString());
  }

  Future<void> addObject(T other) {
    return put(other.id.toString(), other);
  }

  Future<void> addAllObjects(Iterable<T> others) {
    return addAll(others.associateBy((e) => e.id.toString()));
  }

  Future<void> replaceAllObjects(Iterable<T> others) {
    return replaceAll(others.associateBy((e) => e.id.toString()));
  }

  Future<void> removeObject(T other) {
    return remove(other.id.toString());
  }
}
