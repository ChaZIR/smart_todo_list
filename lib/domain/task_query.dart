import 'package:smart_todo_list/domain/models/task.dart';

enum TaskFilter { all, pending, completed, today, overdue, favorite }

enum TaskSort { date, title, deadline }

class TaskQuery {
  final TaskFilter filter;
  final TaskSort sort;
  final String searchQuery;
  final String? category;

  const TaskQuery(
      {this.filter = TaskFilter.all,
      this.sort = TaskSort.date,
      this.searchQuery = '',
      this.category});

  List<Task> apply(Iterable<Task> tasks) {
    final search = searchQuery.trim().toLowerCase();
    var filteredTasks = List<Task>.from(tasks);

    switch (filter) {
      case TaskFilter.pending:
        filteredTasks = filteredTasks.where((t) => !t.isCompleted).toList();
        break;
      case TaskFilter.completed:
        filteredTasks = filteredTasks.where((t) => t.isCompleted).toList();
        break;
      case TaskFilter.today:
        filteredTasks = filteredTasks.where((t) => t.isDueToday).toList();
        break;
      case TaskFilter.overdue:
        filteredTasks = filteredTasks.where((t) => t.isOverdue).toList();
        break;
      case TaskFilter.favorite:
        filteredTasks = filteredTasks.where((t) => t.isFavorite).toList();
        break;
      case TaskFilter.all:
        break;
    }

    if (category != null) {
      filteredTasks =
          filteredTasks.where((t) => t.category == category).toList();
    }

    if (search.isNotEmpty) {
      filteredTasks = filteredTasks.where((t) {
        return t.title.toLowerCase().contains(search) ||
            t.description.toLowerCase().contains(search) ||
            t.tags.any((tag) => tag.toLowerCase().contains(search));
      }).toList();
    }

    switch (sort) {
      case TaskSort.date:
        filteredTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case TaskSort.title:
        filteredTasks.sort((a, b) => a.title.compareTo(b.title));
        break;
      case TaskSort.deadline:
        filteredTasks.sort((a, b) {
          if (a.deadline == null && b.deadline == null) return 0;
          if (a.deadline == null) return 1;
          if (b.deadline == null) return -1;
          return a.deadline!.compareTo(b.deadline!);
        });
        break;
    }

    return List.unmodifiable(filteredTasks);
  }
}
