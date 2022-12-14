import 'dart:convert';
import "package:shared_preferences/shared_preferences.dart";

class Store {
  static void saveString({required String key, required String value}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static void saveMap(
      {required String key, required Map<String, dynamic> value}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(value));
  }

  static Future<String> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  static Future<Map<String, dynamic>> getMap(String key) async {
    try {
      return jsonDecode(await getString(key));
    } catch (error) {
      print(error);
      return {};
    }
  }

  static Future<bool> remove(key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
