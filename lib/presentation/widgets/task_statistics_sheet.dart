import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_todo_list/core/l10n/app_localizations.dart';
import 'package:smart_todo_list/presentation/view_models/task_view_model.dart';

class TaskStatisticsSheet extends StatelessWidget {
  const TaskStatisticsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final taskViewModel = context.watch<TaskViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.insights_rounded,
                        color: colorScheme.primary, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      localizations.translate('statistics'),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.translate('statisticsDescription'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                ..._buildStatCards(context, taskViewModel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStatCards(
      BuildContext context, TaskViewModel taskViewModel) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final stats = <({String label, String value, IconData icon, Color color})>[
      (
        label: localizations.translate('totalTasks'),
        value: taskViewModel.totalTasks.toString(),
        icon: Icons.list_alt_rounded,
        color: colorScheme.primary,
      ),
      (
        label: localizations.translate('completedTasks'),
        value: taskViewModel.completedTasks.toString(),
        icon: Icons.check_circle_rounded,
        color: Colors.green,
      ),
      (
        label: localizations.translate('pendingTasks'),
        value: taskViewModel.pendingTasks.toString(),
        icon: Icons.pending_actions_rounded,
        color: Colors.orange,
      ),
      (
        label: localizations.translate('overdueCount'),
        value: taskViewModel.overdueTasks.toString(),
        icon: Icons.warning_rounded,
        color: Colors.red,
      ),
      (
        label: localizations.translate('favorites'),
        value: taskViewModel.favoriteTasks.toString(),
        icon: Icons.star_rounded,
        color: Colors.amber,
      ),
    ];

    return stats
        .map((stat) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: stat.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (stat.color).withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: stat.color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        stat.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        stat.label,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      stat.value,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: stat.color,
                      ),
                    ),
                  ],
                ),
              ),
            ))
        .toList();
  }
}
