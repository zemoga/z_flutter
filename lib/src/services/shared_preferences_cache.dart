import 'package:shared_preferences/shared_preferences.dart';
import 'package:z_dart/convert.dart';
import 'package:z_dart/io.dart';

class SharedPreferencesCache<K, V> extends Cache<K, V> {
  final String name;
  final JsonMapper<V> _jsonMapper;
  final _prefsData = <String, V>{};

  SharedPreferencesCache(this.name, this._jsonMapper) : super();

  Future<Map<String, V>> _getPrefsData() =>
      SharedPreferences.getInstance().then((prefs) {
        if (_prefsData.isEmpty && prefs.containsKey(name)) {
          final Map<String, dynamic> jsonObj =
              jsonDecode(prefs.getString(name)!);
          final Map<String, V> prefsData = jsonObj
              .map((key, value) => MapEntry(key, _jsonMapper.fromJson(value)));

          _prefsData.clear();
          _prefsData.addAll(prefsData);
        }

        return _prefsData;
      });

  Future<void> _setPrefsData(Map<String, V> prefsData) =>
      SharedPreferences.getInstance().then((prefs) {
        _prefsData.addAll(prefsData);

        final Map<String, dynamic> jsonObj = _prefsData
            .map((key, value) => MapEntry(key, _jsonMapper.toJson(value)));
        prefs.setString(name, jsonEncode(jsonObj));
      });

  @override
  Future<List<V>> getAll() =>
      _getPrefsData().then((prefsData) => prefsData.values.toList());

  @override
  Future<V?> getOrNull(K key) =>
      _getPrefsData().then((prefsData) => prefsData[key.toString()]);

  @override
  Future<bool> contains(K key) => _getPrefsData()
      .then((prefsData) => prefsData.containsKey(key.toString()));

  @override
  Future<void> onPut(Map<K, V> map) =>
      _setPrefsData(map.map((key, value) => MapEntry(key.toString(), value)));

  @override
  Future<void> onRemove(K key) => _getPrefsData().then((prefsData) {
        prefsData.remove(key.toString());
        _setPrefsData(prefsData);
      });

  @override
  Future<void> onClear() => _getPrefsData().then((prefsData) {
        prefsData.clear();
        _setPrefsData(prefsData);
      });
}
