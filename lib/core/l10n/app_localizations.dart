import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Todo List',
      'tasks': 'Tasks',
      'addTask': 'Add Task',
      'editTask': 'Edit Task',
      'taskTitle': 'Task Title',
      'taskDescription': 'Description',
      'category': 'TaskCategory',
      'tags': 'Tags',
      'deadline': 'Deadline',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'completed': 'Completed',
      'pending': 'Pending',
      'all': 'All',
      'today': 'Today',
      'overdue': 'Overdue',
      'noTasks': 'No tasks yet',
      'noTasksDescription': 'Tap + to create your first task',
      'deleteTaskConfirm': 'Delete this task?',
      'yes': 'Yes',
      'no': 'No',
      'search': 'Search tasks...',
      'filter': 'Filter',
      'sort': 'Sort',
      'sortByDate': 'Sort by Date',
      'sortByTitle': 'Sort by Title',
      'sortByDeadline': 'Sort by Deadline',
      'settings': 'Settings',
      'theme': 'Theme',
      'darkMode': 'Dark Mode',
      'lightMode': 'Light Mode',
      'language': 'Language',
      'exportData': 'Export Data',
      'importData': 'Import Data',
      'about': 'About',
      'version': 'Version',
      'work': 'Work',
      'personal': 'Personal',
      'shopping': 'Shopping',
      'health': 'Health',
      'study': 'Study',
      'home': 'Home',
      'addTag': 'Add tag',
      'enterTag': 'Enter tag name',
      'add': 'Add',
      'setDeadline': 'Set Deadline',
      'removeDeadline': 'Remove Deadline',
      'setReminder': 'Set Reminder',
      'reminderSet': 'Reminder set for',
      'taskCompleted': 'Task completed!',
      'taskDeleted': 'Task deleted',
      'undo': 'Undo',
      'exportSuccess': 'Data exported successfully',
      'importSuccess': 'Data imported successfully',
      'importError': 'Error importing data',
      'selectFile': 'Select file',
      'noCategory': 'No category',
      'dueToday': 'Due today',
      'dueTomorrow': 'Due tomorrow',
      'taskDetails': 'Task Details',
      'createdAt': 'Created',
      'statistics': 'Statistics',
      'totalTasks': 'Total tasks',
      'completedTasks': 'Completed',
      'pendingTasks': 'Pending',
      'overdueCount': 'Overdue',
      'favorite': 'Favorite',
      'favorites': 'Favorites',
      'addToFavorites': 'Add to Favorites',
      'removeFromFavorites': 'Remove from Favorites',
      'showFilters': 'Show Filters',
      'hideFilters': 'Hide Filters',
      'viewTask': 'View Task',
      'edit': 'Edit',
      'status': 'Status',
      'categories': 'Categories',
      'sortBy': 'Sort by',
      'statisticsDescription': 'Statistics for all your tasks',
      'enterTitle': 'Enter title',
      'enterDescription': 'Enter description',
      'notSet': 'Not set',
      'data': 'Data',
      'exportDescription': 'Save all tasks to a file',
      'importDescription': 'Load tasks from a file',
      'darkModeDescription': 'Use dark theme',
      'lightModeDescription': 'Use light theme',
      'noFavorites': 'No favorites',
      'noFavoritesDescription': 'Your favorite tasks will appear here',
      'browseTasks': 'Browse tasks',
    },
    'ru': {
      'appTitle': 'Список задач',
      'tasks': 'Задачи',
      'addTask': 'Добавить задачу',
      'editTask': 'Редактировать задачу',
      'taskTitle': 'Название задачи',
      'taskDescription': 'Описание',
      'category': 'Категория',
      'tags': 'Теги',
      'deadline': 'Срок',
      'save': 'Сохранить',
      'cancel': 'Отмена',
      'delete': 'Удалить',
      'completed': 'Завершенные',
      'pending': 'В процессе',
      'all': 'Все',
      'today': 'Сегодня',
      'overdue': 'Просроченные',
      'noTasks': 'Нет задач',
      'noTasksDescription': 'Нажмите +, чтобы создать первую задачу',
      'deleteTaskConfirm': 'Удалить эту задачу?',
      'yes': 'Да',
      'no': 'Нет',
      'search': 'Поиск задач...',
      'filter': 'Фильтр',
      'sort': 'Сортировка',
      'sortByDate': 'По дате',
      'sortByTitle': 'По названию',
      'sortByDeadline': 'По сроку',
      'settings': 'Настройки',
      'theme': 'Тема',
      'darkMode': 'Темная тема',
      'lightMode': 'Светлая тема',
      'language': 'Язык',
      'exportData': 'Экспорт данных',
      'importData': 'Импорт данных',
      'about': 'О приложении',
      'version': 'Версия',
      'work': 'Работа',
      'personal': 'Личное',
      'shopping': 'Покупки',
      'health': 'Здоровье',
      'study': 'Учёба',
      'home': 'Дом',
      'addTag': 'Добавить тег',
      'enterTag': 'Введите название тега',
      'add': 'Добавить',
      'setDeadline': 'Установить срок',
      'removeDeadline': 'Убрать срок',
      'setReminder': 'Установить напоминание',
      'reminderSet': 'Напоминание установлено на',
      'taskCompleted': 'Задача выполнена!',
      'taskDeleted': 'Задача удалена',
      'undo': 'Отменить',
      'exportSuccess': 'Данные успешно экспортированы',
      'importSuccess': 'Данные успешно импортированы',
      'importError': 'Ошибка импорта данных',
      'selectFile': 'Выберите файл',
      'noCategory': 'Без категории',
      'dueToday': 'Сегодня',
      'dueTomorrow': 'Завтра',
      'taskDetails': 'Детали задачи',
      'createdAt': 'Создано',
      'statistics': 'Статистика',
      'totalTasks': 'Всего задач',
      'completedTasks': 'Завершено',
      'pendingTasks': 'В процессе',
      'overdueCount': 'Просрочено',
      'favorite': 'Избранное',
      'favorites': 'Избранные',
      'addToFavorites': 'Добавить в избранное',
      'removeFromFavorites': 'Убрать из избранного',
      'showFilters': 'Показать фильтры',
      'hideFilters': 'Скрыть фильтры',
      'viewTask': 'Просмотр задачи',
      'edit': 'Редактировать',
      'status': 'Статус',
      'categories': 'Категории',
      'sortBy': 'Сортировка по',
      'statisticsDescription': 'Статистика по всем вашим задачам',
      'enterTitle': 'Введите название',
      'enterDescription': 'Введите описание',
      'notSet': 'Не установлено',
      'data': 'Данные',
      'exportDescription': 'Сохранить все задачи в файл',
      'importDescription': 'Загрузить задачи из файла',
      'darkModeDescription': 'Использовать темную тему',
      'lightModeDescription': 'Использовать светлую тему',
      'noFavorites': 'Нет избранных',
      'noFavoritesDescription': 'Здесь появятся ваши избранные задачи',
      'browseTasks': 'Обзор задач',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]![key] ?? key;
  }

  String get appTitle => translate('appTitle');
  String get tasks => translate('tasks');
  String get addTask => translate('addTask');
  String get editTask => translate('editTask');
  String get taskTitle => translate('taskTitle');
  String get taskDescription => translate('taskDescription');
  String get category => translate('category');
  String get tags => translate('tags');
  String get deadline => translate('deadline');
  String get save => translate('save');
  String get cancel => translate('cancel');
  String get delete => translate('delete');
  String get completed => translate('completed');
  String get pending => translate('pending');
  String get all => translate('all');
  String get today => translate('today');
  String get overdue => translate('overdue');
  String get noTasks => translate('noTasks');
  String get noTasksDescription => translate('noTasksDescription');
  String get deleteTaskConfirm => translate('deleteTaskConfirm');
  String get yes => translate('yes');
  String get no => translate('no');
  String get search => translate('search');
  String get filter => translate('filter');
  String get sort => translate('sort');
  String get settings => translate('settings');
  String get theme => translate('theme');
  String get darkMode => translate('darkMode');
  String get lightMode => translate('lightMode');
  String get language => translate('language');
  String get exportData => translate('exportData');
  String get importData => translate('importData');
  String get about => translate('about');
  String get status => translate('status');
  String get categories => translate('categories');
  String get sortBy => translate('sortBy');
  String get statisticsDescription => translate('statisticsDescription');
  String get enterTitle => translate('enterTitle');
  String get enterDescription => translate('enterDescription');
  String get notSet => translate('notSet');
  String get data => translate('data');
  String get exportDescription => translate('exportDescription');
  String get importDescription => translate('importDescription');
  String get darkModeDescription => translate('darkModeDescription');
  String get lightModeDescription => translate('lightModeDescription');
  String get noFavorites => translate('noFavorites');
  String get noFavoritesDescription => translate('noFavoritesDescription');
  String get browseTasks => translate('browseTasks');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
