import 'package:fitness_health_tracker/helpers/sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  var themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(themeMode.value);
    _saveTheme();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedMode = prefs.getInt(SharedPreferenceKey.themeMode) ?? 0;
    themeMode.value = ThemeMode.values[storedMode];
    Get.changeThemeMode(themeMode.value);
  }

  void _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(SharedPreferenceKey.themeMode, themeMode.value.index);
  }
}
