import 'package:smart_todo_list/data/services/storage_service.dart';
import 'package:smart_todo_list/data/services/task_reminder_service.dart';
import 'package:smart_todo_list/domain/models/task.dart';

class TaskRepository {
  final StorageService _storage;
  final TaskReminderService _reminders;
  final List<Task> _tasks = [];
  late final Future<void> ready = _load();

  TaskRepository(this._storage, this._reminders);

  List<Task> get tasks => List.unmodifiable(_tasks);

  Future<void> _load() async {
    _tasks.addAll(await _storage.loadTasks());
  }

  Future<void> _persist() => _storage.saveTasks(_tasks);

  Future<void> add(Task task) async {
    await ready;
    await _reminders.synchronize(task);
    _tasks.add(task);
    await _persist();
  }

  Future<void> update(Task task) async {
    await ready;
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    task.notificationId = _tasks[index].notificationId;
    await _reminders.synchronize(task);
    _tasks[index] = task;
    await _persist();
  }

  Future<void> delete(String taskId) async {
    await ready;
    final index = _tasks.indexWhere((item) => item.id == taskId);
    if (index == -1) return;
    await _reminders.cancel(_tasks[index]);
    _tasks.removeAt(index);
    await _persist();
  }

  Future<void> toggleCompletion(String taskId) async {
    await ready;
    final index = _tasks.indexWhere((item) => item.id == taskId);
    if (index == -1) return;
    final task = _tasks[index];
    await update(task.copyWith(isCompleted: !task.isCompleted));
  }

  Future<void> toggleFavorite(String taskId) async {
    await ready;
    final index = _tasks.indexWhere((item) => item.id == taskId);
    if (index == -1) return;
    final task = _tasks[index];
    _tasks[index] = task.copyWith(isFavorite: !task.isFavorite);
    await _persist();
  }
}
