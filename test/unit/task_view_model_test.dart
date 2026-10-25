import 'package:smart_todo_list/data/repositories/task_repository.dart';
import 'package:smart_todo_list/data/services/task_reminder_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_todo_list/domain/models/task.dart';
import 'package:smart_todo_list/presentation/view_models/task_view_model.dart';
import 'package:smart_todo_list/data/services/notification_service.dart';
import 'package:smart_todo_list/data/services/storage_service.dart';

class FakeNotifications implements NotificationService {
  final scheduled = <int>{};
  int _nextId = 0;

  @override
  int generateNotificationId() => ++_nextId;

  @override
  Future<void> scheduleNotification(
      {required int id,
      required String title,
      required String body,
      required DateTime scheduledDate}) async {
    scheduled.add(id);
  }

  @override
  Future<void> cancelNotification(int id) async => scheduled.remove(id);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Persists reminder ID and cancels it after loading the task again',
      () async {
    final notifications = FakeNotifications();
    final provider = TaskViewModel(
        TaskRepository(StorageService(), TaskReminderService(notifications)));
    addTearDown(provider.dispose);
    final task = Task(
        id: 'one',
        title: 'Interview',
        createdAt: DateTime.now(),
        deadline: DateTime.now().add(const Duration(days: 1)));
    await provider.addTask(task);
    final saved = await StorageService().loadTasks();
    expect(saved.single.notificationId, task.notificationId);
    expect(task.notificationId, isNotNull);
    final reloaded = TaskViewModel(
        TaskRepository(StorageService(), TaskReminderService(notifications)));
    addTearDown(reloaded.dispose);
    await reloaded.ready;
    await reloaded.toggleTaskCompletion('one');
    expect(notifications.scheduled, isEmpty);
    expect((await StorageService().loadTasks()).single.notificationId, isNull);
    await reloaded.toggleTaskCompletion('one');
    expect(notifications.scheduled, hasLength(1));
  });

  test('Search and completion filters combine with category selection',
      () async {
    final provider = TaskViewModel(TaskRepository(
        StorageService(), TaskReminderService(FakeNotifications())));
    addTearDown(provider.dispose);
    await provider.addTask(Task(
        id: 'one',
        title: 'Flutter',
        category: 'work',
        createdAt: DateTime(2026)));
    await provider.addTask(Task(
        id: 'two',
        title: 'Shopping',
        category: 'home',
        createdAt: DateTime(2026)));
    provider.setSearchQuery(' FLUTTER ');
    provider.setSelectedCategory('work');
    provider.setFilter(TaskFilter.pending);
    expect(provider.tasks.map((task) => task.id), ['one']);
    await provider.toggleTaskCompletion('one');
    expect(provider.tasks, isEmpty);
  });

  test('A copied task owns its tags', () {
    final original = Task(
        id: 'one', title: 'Task', createdAt: DateTime(2026), tags: ['work']);
    original.copyWith().tags.add('edited');
    expect(original.tags, ['work']);
  });
}
