import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smart_todo_list/core/l10n/app_localizations.dart';
import 'package:smart_todo_list/data/repositories/settings_repository.dart';
import 'package:smart_todo_list/data/repositories/task_repository.dart';
import 'package:smart_todo_list/data/services/notification_service.dart';
import 'package:smart_todo_list/data/services/storage_service.dart';
import 'package:smart_todo_list/data/services/task_reminder_service.dart';
import 'package:smart_todo_list/presentation/screens/home_screen.dart';
import 'package:smart_todo_list/presentation/view_models/language_view_model.dart';
import 'package:smart_todo_list/presentation/view_models/task_view_model.dart';
import 'package:smart_todo_list/presentation/view_models/theme_view_model.dart';

class SmartTodoApp extends StatelessWidget {
  final NotificationService? notificationService;

  const SmartTodoApp({super.key, this.notificationService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => StorageService()),
        Provider(
            create: (context) =>
                SettingsRepository(context.read<StorageService>())),
        Provider(create: (_) => notificationService ?? NotificationService()),
        Provider(
            create: (context) =>
                TaskReminderService(context.read<NotificationService>())),
        Provider(
            create: (context) => TaskRepository(context.read<StorageService>(),
                context.read<TaskReminderService>())),
        ChangeNotifierProvider(
            create: (context) =>
                ThemeViewModel(context.read<SettingsRepository>())),
        ChangeNotifierProvider(
            create: (context) =>
                LanguageViewModel(context.read<SettingsRepository>())),
        ChangeNotifierProvider(
            create: (context) => TaskViewModel(context.read<TaskRepository>())),
      ],
      child: Consumer2<ThemeViewModel, LanguageViewModel>(
        builder: (context, themeViewModel, languageViewModel, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Todo List',
            theme: themeViewModel.themeData,
            locale: languageViewModel.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ru'),
            ],
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
