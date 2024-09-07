import 'package:weather_today/cores/cached/cached.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCachedImpl implements Cached {
  @override
  Future<String?> get(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(key);
    return data;
  }

  @override
  Future set(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  @override
  Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Future<void> remove(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
