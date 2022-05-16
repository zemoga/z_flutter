part of z.flutter.cache;

///
abstract class BasePersistedCache<T> extends Cache<T> {
  // TODO: Review a "Persistence Strategy" to use as constructor parameter.
  BasePersistedCache(
    this.name,
    T dfltData,
  ) : super(dfltData);

  final String name;
  bool _prefsDataLoaded = false;

  @protected
  T fromRawJson(String rawJson);

  @protected
  String toRawJson(T prefsData);

  Future<T> _loadPrefsData(T dflt) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(name)?.let(fromRawJson) ?? dflt;
  }

  Future<void> _savePrefsData(T prefsData) async {
    final prefs = await SharedPreferences.getInstance();
    return toRawJson(prefsData).let((it) => prefs.setString(name, it));
  }

  @override
  set data(T data) {
    if (!_prefsDataLoaded) {
      _loadPrefsData(data)
          .then((data) => super.data = data)
          .then((_) => _prefsDataLoaded = true);
    } else {
      _savePrefsData(data).then((_) => super.data = data);
    }
  }
}

///
class PersistedCache<T> extends BasePersistedCache<T> {
  PersistedCache(
    String name,
    this.jsonMapper,
    T dfltData,
  ) : super(name, dfltData);

  final JsonMapper<T> jsonMapper;

  @override
  T fromRawJson(String rawJson) {
    final jsonObj = jsonDecode(rawJson);
    return jsonMapper.fromJson(jsonObj);
  }

  @override
  String toRawJson(T prefsData) {
    final jsonObj = jsonMapper.toJson(prefsData);
    return jsonEncode(jsonObj);
  }
}

class PersistedCollectionCache<T> extends BasePersistedCache<Map<String, T>> {
  PersistedCollectionCache(
    String name,
    this.jsonMapper, {
    Map<String, T> initialData = const {},
  }) : super(name, Map.of(initialData));

  static PersistedCollectionCache<T> identifiable<T extends Identifiable>(
    String name,
    JsonMapper<T> jsonMapper, {
    Iterable<T> identifiableList = const [],
  }) {
    return PersistedCollectionCache(
      name,
      jsonMapper,
      initialData: identifiableList.associateBy((e) => e.id.toString()),
    );
  }

  final JsonMapper<T> jsonMapper;

  @override
  Map<String, T> fromRawJson(String rawJson) {
    final Map<String, dynamic> jsonObj = jsonDecode(rawJson);
    return jsonObj
        .map((key, value) => MapEntry(key, jsonMapper.fromJson(value)));
  }

  @override
  String toRawJson(Map<String, T> prefsData) {
    final Map<String, dynamic> jsonObj =
        prefsData.map((key, value) => MapEntry(key, jsonMapper.toJson(value)));
    return jsonEncode(jsonObj);
  }
}
