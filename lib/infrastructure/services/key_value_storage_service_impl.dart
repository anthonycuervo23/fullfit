import 'package:shared_preferences/shared_preferences.dart';
import 'key_value_storage_service.dart';

class KeyValueStorageServiceImplementation extends KeyValueStorageService {
  const KeyValueStorageServiceImplementation();
  static late SharedPreferences _sharedPreferences;

  static Future<void> loadPreferences() async =>
      _sharedPreferences = await SharedPreferences.getInstance();

  // KeyValueStorageServiceImplementation() {
  //   init();
  // }

  // void init() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  // }

  @override
  T? getValue<T>(String key) {
    switch (T) {
      case int:
        return _sharedPreferences.getInt(key) as T?;
      case double:
        return _sharedPreferences.getDouble(key) as T?;
      case String:
        return _sharedPreferences.getString(key) as T?;
      case bool:
        return _sharedPreferences.getBool(key) as T?;
      case List:
        return _sharedPreferences.getStringList(key) as T?;
      default:
        throw Exception('GET - Type not supported: ${T.runtimeType}');
    }
  }

  @override
  Future<bool> removeKey(String key) {
    return _sharedPreferences.remove(key);
  }

  @override
  void setKeyValue<T>(String key, T value) {
    switch (T) {
      case int:
        _sharedPreferences.setInt(key, value as int);
        break;
      case double:
        _sharedPreferences.setDouble(key, value as double);
        break;
      case String:
        _sharedPreferences.setString(key, value as String);
        break;
      case bool:
        _sharedPreferences.setBool(key, value as bool);
        break;
      case List:
        _sharedPreferences.setStringList(key, value as List<String>);
        break;
      default:
        throw Exception('SET - Type not supported: ${T.runtimeType}');
    }
  }
}
