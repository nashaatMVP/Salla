import 'package:flutter/material.dart';
import '../shared/theme/theme_data.dart';

class ThemeProvider with ChangeNotifier {

  /// Default theme is light
  ThemeData _currentTheme = AppTheme.light;
  ThemeData get currentTheme => _currentTheme;

  /// Toggle between themes
  void toggleTheme() {
    if (_currentTheme == AppTheme.light) {
      _currentTheme = AppTheme.dark;
    } else {
      _currentTheme = AppTheme.light;
    }
    notifyListeners();
  }

  /// Change to a specific theme
  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }

}

