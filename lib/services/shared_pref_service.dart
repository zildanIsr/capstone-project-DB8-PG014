import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  const SharedPrefService();

  Future<void> addString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString(key, value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setBool(key, value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setInt(key, value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setDouble(key, value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      String? val = prefs.getString(key);
      return val ?? "";
    } catch (e) {
      debugPrint(e.toString());
      return "";
    }
  }

  Future<bool> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      bool? val = prefs.getBool(key);
      return val ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      int? val = prefs.getInt(key);
      return val;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      return prefs.getDouble(key);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}

class SharedPrefKeys {
  static const themeModeKey = "Setting_Theme_Mode";
}
