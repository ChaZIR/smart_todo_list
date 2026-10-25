import 'package:flutter/material.dart';
import 'package:smart_todo_list/core/disposable_notifier.dart';
import 'package:smart_todo_list/core/theme/app_theme.dart';
import 'package:smart_todo_list/data/repositories/settings_repository.dart';

class ThemeViewModel extends DisposableNotifier {
  bool _isDarkMode = false;
  late final Future<void> _ready;
  final SettingsRepository _settings;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode ? AppTheme.dark : AppTheme.light;

  ThemeViewModel(this._settings) {
    _ready = _loadTheme();
  }

  Future<void> _loadTheme() async {
    _isDarkMode = await _settings.loadTheme();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    await _ready;
    _isDarkMode = !_isDarkMode;
    await _settings.saveTheme(_isDarkMode);
    notifyListeners();
  }
}
