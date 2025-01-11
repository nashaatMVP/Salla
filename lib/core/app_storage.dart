import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  SharedPreferences? _preferences;

  Future<AppStorage> init() async {
    _preferences = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> getBool(String key) async {
    return _preferences?.getBool(key) ?? false;
  }

  Future<bool?> getUnsafeBool(String key) async {
    return _preferences?.getBool(key);
  }

  Future<bool> setBool(String key, {required bool value}) async {
    return await _preferences!.setBool(key, value);
  }

  Future<bool> logout() async {
    await _preferences?.clear();
    await onBoarding();
    return true;
  }

  Future<bool> setString(String key, String? value) async {
    if (value != null) {
      return await _preferences?.setString(key, value) ?? false;
    }
    return removeString(key);
  }

  String? getString(String key) {
    return _preferences?.getString(key);
  }

  Future<bool> removeString(String key) async {
    return await _preferences!.remove(key);
  }

  Future<void> onBoarding() async {
    await setBool("on_board", value: true);
  }

  Future<bool> isOnBoarded() async {
    return await getBool("on_board");
  }
}