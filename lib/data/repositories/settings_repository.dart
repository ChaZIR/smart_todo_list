import 'package:smart_todo_list/data/services/storage_service.dart';

class SettingsRepository {
  final StorageService _storage;

  SettingsRepository(this._storage);

  Future<bool> loadTheme() => _storage.loadTheme();
  Future<void> saveTheme(bool isDarkMode) => _storage.saveTheme(isDarkMode);
  Future<String?> loadLanguage() => _storage.loadLanguage();
  Future<void> saveLanguage(String code) => _storage.saveLanguage(code);
}
