import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_todo_list/core/l10n/app_localizations.dart';
import 'package:smart_todo_list/core/utils/date_helper.dart';
import 'package:smart_todo_list/domain/models/task.dart';
import 'package:smart_todo_list/presentation/models/task_category.dart';
import 'package:smart_todo_list/presentation/view_models/language_view_model.dart';
import 'package:smart_todo_list/presentation/view_models/task_view_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    final languageViewModel = Provider.of<LanguageViewModel>(context);
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(localizations.delete),
            content: Text(localizations.deleteTaskConfirm),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(localizations.no),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(localizations.yes),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        taskViewModel.deleteTask(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.translate('taskDeleted')),
            backgroundColor: colorScheme.surface,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            action: SnackBarAction(
              label: localizations.translate('undo'),
              textColor: colorScheme.primary,
              onPressed: () {
                taskViewModel.addTask(task);
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
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
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: task.isCompleted
                              ? colorScheme.primary
                              : colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isCompleted
                                    ? colorScheme.onSurface
                                        .withValues(alpha: 0.5)
                                    : colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (task.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                task.description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          if (category != null)
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: category.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: category.color.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  category.icon,
                                  color: category.color,
                                  size: 20,
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: task.isFavorite
                                  ? Colors.amber.withValues(alpha: 0.1)
                                  : colorScheme.surfaceContainerHighest
                                      .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: task.isFavorite
                                    ? Colors.amber.withValues(alpha: 0.3)
                                    : colorScheme.outline
                                        .withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                task.isFavorite
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 20,
                                color: task.isFavorite
                                    ? Colors.amber
                                    : colorScheme.onSurfaceVariant,
                              ),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                taskViewModel.toggleTaskFavorite(task.id);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (task.deadline != null || task.tags.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateHelper.formatDate(
                                  task.createdAt,
                                  languageViewModel.locale.languageCode,
                                ),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (task.deadline != null)
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
                                  size: 14,
                                  color: task.isOverdue
                                      ? Colors.red
                                      : task.isDueToday
                                          ? Colors.orange
                                          : colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateHelper.getRelativeDate(
                                    task.deadline!,
                                    languageViewModel.locale.languageCode,
                                  ),
                                  style: theme.textTheme.labelSmall?.copyWith(
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
                          ),
                        ...task.tags.map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colorScheme.secondary.withValues(alpha: 0.1),
                                  colorScheme.secondary.withValues(alpha: 0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.secondary
                                    .withValues(alpha: 0.3),
                                width: 1,
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
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
