import 'package:smart_todo_list/data/services/notification_service.dart';
import 'package:smart_todo_list/domain/models/task.dart';

class TaskReminderService {
  final NotificationService _notifications;

  TaskReminderService(this._notifications);

  Future<void> synchronize(Task task) async {
    final previousId = task.notificationId;
    if (previousId != null) {
      await _notifications.cancelNotification(previousId);
      task.notificationId = null;
    }
    final deadline = task.deadline;
    if (deadline == null || task.isCompleted) return;
    final reminderTime = deadline.subtract(const Duration(hours: 1));
    if (!reminderTime.isAfter(DateTime.now())) return;
    final id = _notifications.generateNotificationId();
    await _notifications.scheduleNotification(
      id: id,
      title: 'Напоминание о задаче',
      body: task.title,
      scheduledDate: reminderTime,
    );
    task.notificationId = id;
  }

  Future<void> cancel(Task task) async {
    final id = task.notificationId;
    if (id != null) await _notifications.cancelNotification(id);
  }
}
