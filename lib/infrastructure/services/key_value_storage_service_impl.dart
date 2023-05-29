import 'package:shared_preferences/shared_preferences.dart';
import 'key_value_storage_service.dart';

class KeyValueStorageServiceImplementation extends KeyValueStorageService {
  late SharedPreferences sharedPreferences;

  KeyValueStorageServiceImplementation() {
    init();
  }

  void init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  T? getValue<T>(String key) {
    switch (T) {
      case int:
        return sharedPreferences.getInt(key) as T?;
      case double:
        return sharedPreferences.getDouble(key) as T?;
      case String:
        return sharedPreferences.getString(key) as T?;
      case bool:
        return sharedPreferences.getBool(key) as T?;
      case List:
        return sharedPreferences.getStringList(key) as T?;
      default:
        throw Exception('GET - Type not supported: ${T.runtimeType}');
    }
  }

  @override
  Future<bool> removeKey(String key) {
    return sharedPreferences.remove(key);
  }

  @override
  void setKeyValue<T>(String key, T value) {
    switch (T) {
      case int:
        sharedPreferences.setInt(key, value as int);
        break;
      case double:
        sharedPreferences.setDouble(key, value as double);
        break;
      case String:
        sharedPreferences.setString(key, value as String);
        break;
      case bool:
        sharedPreferences.setBool(key, value as bool);
        break;
      case List:
        sharedPreferences.setStringList(key, value as List<String>);
        break;
      default:
        throw Exception('SET - Type not supported: ${T.runtimeType}');
    }
  }
}
