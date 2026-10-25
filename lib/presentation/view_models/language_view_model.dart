import 'package:flutter/material.dart';
import 'package:smart_todo_list/core/disposable_notifier.dart';
import 'package:smart_todo_list/data/repositories/settings_repository.dart';

class LanguageViewModel extends DisposableNotifier {
  Locale _locale = const Locale('ru');
  late final Future<void> _ready;
  final SettingsRepository _settings;

  Locale get locale => _locale;

  LanguageViewModel(this._settings) {
    _ready = _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final languageCode = await _settings.loadLanguage();
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    await _ready;
    if (_locale.languageCode == languageCode) return;

    _locale = Locale(languageCode);
    await _settings.saveLanguage(languageCode);
    notifyListeners();
  }

  bool get isRussian => _locale.languageCode == 'ru';
  bool get isEnglish => _locale.languageCode == 'en';
}
