
abstract class Cached {
  Future<String?> get(String key);
  Future<void> set(String key, String value);
  Future<void> clear();
  Future<void> remove(String key);
}