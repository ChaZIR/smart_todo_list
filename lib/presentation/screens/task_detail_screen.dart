import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_todo_list/core/l10n/app_localizations.dart';
import 'package:smart_todo_list/core/utils/date_helper.dart';
import 'package:smart_todo_list/domain/models/task.dart';
import 'package:smart_todo_list/presentation/models/task_category.dart';
import 'package:smart_todo_list/presentation/screens/add_edit_task_screen.dart';
import 'package:smart_todo_list/presentation/view_models/language_view_model.dart';
import 'package:smart_todo_list/presentation/view_models/task_view_model.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final taskViewModel = context.watch<TaskViewModel>();
    final task = taskViewModel.taskById(this.task.id) ?? this.task;
    final languageViewModel = Provider.of<LanguageViewModel>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    TaskCategory? category;
    if (task.category != null) {
      try {
        category = TaskCategory.defaultCategories.firstWhere(
          (c) => c.name == task.category,
        );
      } catch (e) {
        category = null;
      }
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            backgroundColor: isDark
                ? colorScheme.surface.withValues(alpha: 0.95)
                : colorScheme.surface.withValues(alpha: 0.98),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              localizations.translate('taskDetails'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton.filledTonal(
                onPressed: () => _showDeleteDialog(context),
                icon: const Icon(Icons.delete_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: task.isCompleted
                                ? colorScheme.primary
                                : task.isOverdue
                                    ? Colors.red.withValues(alpha: 0.1)
                                    : colorScheme.surfaceContainerHighest
                                        .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: task.isCompleted
                                  ? colorScheme.primary
                                  : task.isOverdue
                                      ? Colors.red.withValues(alpha: 0.3)
                                      : colorScheme.outline
                                          .withValues(alpha: 0.1),
                            ),
                          ),
                          child: Transform.scale(
                            scale: 1.4,
                            child: Checkbox(
                              value: task.isCompleted,
                              onChanged: (value) {
                                taskViewModel.toggleTaskCompletion(task.id);
                              },
                              activeColor: Colors.transparent,
                              checkColor: colorScheme.onPrimary,
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: task.isCompleted
                                      ? colorScheme.onSurface
                                          .withValues(alpha: 0.5)
                                      : colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: task.isCompleted
                                      ? Colors.green.withValues(alpha: 0.1)
                                      : task.isOverdue
                                          ? Colors.red.withValues(alpha: 0.1)
                                          : colorScheme.primary
                                              .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: task.isCompleted
                                        ? Colors.green.withValues(alpha: 0.3)
                                        : task.isOverdue
                                            ? Colors.red.withValues(alpha: 0.3)
                                            : colorScheme.primary
                                                .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      task.isCompleted
                                          ? Icons.check_circle_rounded
                                          : task.isOverdue
                                              ? Icons.warning_amber_rounded
                                              : Icons.pending_actions_rounded,
                                      size: 14,
                                      color: task.isCompleted
                                          ? Colors.green
                                          : task.isOverdue
                                              ? Colors.red
                                              : colorScheme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      task.isCompleted
                                          ? localizations.completed
                                          : task.isOverdue
                                              ? localizations.overdue
                                              : localizations.pending,
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: task.isCompleted
                                            ? Colors.green
                                            : task.isOverdue
                                                ? Colors.red
                                                : colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (category != null) ...[
                          _buildDetailItem(
                            context,
                            localizations.category,
                            Icons.category_rounded,
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color:
                                        category.color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          category.color.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      category.icon,
                                      size: 18,
                                      color: category.color,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  localizations.translate(category.name),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: category.color,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        _buildDetailItem(
                          context,
                          localizations.translate('createdAt'),
                          Icons.access_time_rounded,
                          Text(
                            DateHelper.formatDateTime(
                              task.createdAt,
                              languageViewModel.locale.languageCode,
                            ),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (task.deadline != null) ...[
                          _buildDetailItem(
                            context,
                            localizations.deadline,
                            Icons.calendar_today_rounded,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: task.isOverdue
                                      ? [
                                          Colors.red.withValues(alpha: 0.1),
                                          Colors.red.withValues(alpha: 0.05)
                                        ]
                                      : task.isDueToday
                                          ? [
                                              Colors.orange
                                                  .withValues(alpha: 0.1),
                                              Colors.orange
                                                  .withValues(alpha: 0.05)
                                            ]
                                          : [
                                              colorScheme.primary
                                                  .withValues(alpha: 0.1),
                                              colorScheme.primary
                                                  .withValues(alpha: 0.05)
                                            ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: task.isOverdue
                                      ? Colors.red.withValues(alpha: 0.3)
                                      : task.isDueToday
                                          ? Colors.orange.withValues(alpha: 0.3)
                                          : colorScheme.primary
                                              .withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    task.isOverdue
                                        ? Icons.warning_amber_rounded
                                        : Icons.calendar_today_rounded,
                                    size: 16,
                                    color: task.isOverdue
                                        ? Colors.red
                                        : task.isDueToday
                                            ? Colors.orange
                                            : colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateHelper.formatDateTime(
                                          task.deadline!,
                                          languageViewModel.locale.languageCode,
                                        ),
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: task.isOverdue
                                              ? Colors.red
                                              : task.isDueToday
                                                  ? Colors.orange
                                                  : colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (task.tags.isNotEmpty) ...[
                          _buildDetailItem(
                            context,
                            localizations.tags,
                            Icons.tag_rounded,
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: task.tags.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: colorScheme.secondary
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.tag_rounded,
                                        size: 14,
                                        color: colorScheme.secondary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        tag,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: colorScheme.secondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (task.description.isNotEmpty) ...[
                          _buildDetailItem(
                            context,
                            localizations.taskDescription,
                            Icons.description_rounded,
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colorScheme.outline
                                      .withValues(alpha: 0.1),
                                ),
                              ),
                              child: Text(
                                task.description,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurface,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditTaskScreen(task: task),
            ),
          );
        },
        icon: const Icon(Icons.edit_rounded),
        label: Text(localizations.translate('edit')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        highlightElevation: 8,
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String title,
    IconData icon,
    Widget content,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 48),
          child: content,
        ),
      ],
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          localizations.delete,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          localizations.deleteTaskConfirm,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: colorScheme.surface,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
            child: Text(
              localizations.no,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await taskViewModel.deleteTask(task.id);
              if (context.mounted) {
                Navigator.of(context).pop(true);
                Navigator.of(context).pop();
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(
              localizations.yes,
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
