import 'package:flutter/widgets.dart';
import 'package:smart_todo_list/app/app.dart';
import 'package:smart_todo_list/data/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notifications = NotificationService();
  await notifications.initialize();
  runApp(SmartTodoApp(notificationService: notifications));
}
