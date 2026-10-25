import 'package:smart_todo_list/core/disposable_notifier.dart';
import 'package:smart_todo_list/data/repositories/task_repository.dart';
import 'package:smart_todo_list/domain/models/task.dart';
import 'package:smart_todo_list/domain/task_query.dart';
import 'package:uuid/uuid.dart';

export 'package:smart_todo_list/domain/task_query.dart'
    show TaskFilter, TaskSort;

class TaskViewModel extends DisposableNotifier {
  final TaskRepository _repository;
  late final Future<void> ready;
  TaskFilter _currentFilter = TaskFilter.all;
  TaskSort _currentSort = TaskSort.date;
  String _searchQuery = '';
  String? _selectedCategory;

  TaskViewModel(this._repository) {
    ready = _repository.ready.then((_) => notifyListeners());
  }

  List<Task> get tasks => TaskQuery(
        filter: _currentFilter,
        sort: _currentSort,
        searchQuery: _searchQuery,
        category: _selectedCategory,
      ).apply(_repository.tasks);
  Task? taskById(String id) {
    for (final task in _repository.tasks) {
      if (task.id == id) return task;
    }
    return null;
  }

  TaskFilter get currentFilter => _currentFilter;
  TaskSort get currentSort => _currentSort;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;

  int get totalTasks => _repository.tasks.length;
  int get completedTasks =>
      _repository.tasks.where((t) => t.isCompleted).length;
  int get pendingTasks => _repository.tasks.where((t) => !t.isCompleted).length;
  int get overdueTasks => _repository.tasks.where((t) => t.isOverdue).length;
  int get todayTasks => _repository.tasks.where((t) => t.isDueToday).length;
  int get favoriteTasks => _repository.tasks.where((t) => t.isFavorite).length;

  Future<void> _change(Future<void> Function() operation) async {
    await operation();
    notifyListeners();
  }

  Future<void> addTask(Task task) => _change(() => _repository.add(task));
  Future<void> updateTask(Task task) => _change(() => _repository.update(task));
  Future<void> deleteTask(String id) => _change(() => _repository.delete(id));
  Future<void> toggleTaskCompletion(String id) =>
      _change(() => _repository.toggleCompletion(id));
  Future<void> toggleTaskFavorite(String id) =>
      _change(() => _repository.toggleFavorite(id));

  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void setSort(TaskSort sort) {
    _currentSort = sort;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Task createNewTask({
    required String title,
    String description = '',
    DateTime? deadline,
    String? category,
    List<String>? tags,
  }) {
    return Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      deadline: deadline,
      category: category,
      tags: tags,
    );
  }
}
