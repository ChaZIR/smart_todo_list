import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_todo_list/core/l10n/app_localizations.dart';
import 'package:smart_todo_list/presentation/models/task_category.dart';
import 'package:smart_todo_list/presentation/view_models/task_view_model.dart';

class TaskFilters extends StatelessWidget {
  const TaskFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final taskViewModel = Provider.of<TaskViewModel>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        _buildSectionHeader(
          context,
          localizations.translate('status'),
          Icons.filter_list_rounded,
        ),
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildFilterChip(
                context,
                localizations.all,
                TaskFilter.all,
                taskViewModel.currentFilter,
                Icons.all_inclusive_rounded,
                colorScheme.primary,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                localizations.pending,
                TaskFilter.pending,
                taskViewModel.currentFilter,
                Icons.pending_actions_rounded,
                colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                localizations.completed,
                TaskFilter.completed,
                taskViewModel.currentFilter,
                Icons.check_circle_outline_rounded,
                Colors.green,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                localizations.today,
                TaskFilter.today,
                taskViewModel.currentFilter,
                Icons.today_rounded,
                colorScheme.tertiary,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                localizations.overdue,
                TaskFilter.overdue,
                taskViewModel.currentFilter,
                Icons.warning_amber_rounded,
                Colors.red,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                localizations.translate('favorite'),
                TaskFilter.favorite,
                taskViewModel.currentFilter,
                Icons.star_border_rounded,
                Colors.amber,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader(
          context,
          localizations.translate('categories'),
          Icons.category_rounded,
        ),
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildCategoryChip(
                context,
                localizations.translate('noCategory'),
                null,
                taskViewModel.selectedCategory,
                Icons.all_inclusive_rounded,
                colorScheme.primary,
              ),
              const SizedBox(width: 8),
              ...TaskCategory.defaultCategories.map(
                (category) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildCategoryChip(
                    context,
                    localizations.translate(category.name),
                    category.name,
                    taskViewModel.selectedCategory,
                    category.icon,
                    category.color,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader(
          context,
          localizations.translate('sortBy'),
          Icons.sort_rounded,
        ),
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildSortButton(
                context,
                localizations.translate('sortByDate'),
                TaskSort.date,
                taskViewModel.currentSort,
                Icons.calendar_today_rounded,
                colorScheme.primary,
              ),
              const SizedBox(width: 8),
              _buildSortButton(
                context,
                localizations.translate('sortByTitle'),
                TaskSort.title,
                taskViewModel.currentSort,
                Icons.text_fields_rounded,
                colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              _buildSortButton(
                context,
                localizations.translate('sortByDeadline'),
                TaskSort.deadline,
                taskViewModel.currentSort,
                Icons.hourglass_bottom_rounded,
                colorScheme.tertiary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    TaskFilter filter,
    TaskFilter currentFilter,
    IconData icon,
    Color iconColor,
  ) {
    final isSelected = filter == currentFilter;
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ElevatedButton.icon(
      onPressed: () {
        taskViewModel.setFilter(filter);
      },
      icon: Icon(icon,
          size: 18, color: isSelected ? colorScheme.onPrimary : iconColor),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        foregroundColor:
            isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    String? categoryName,
    String? selectedCategory,
    IconData icon,
    Color color,
  ) {
    final isSelected = categoryName == selectedCategory;
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ElevatedButton.icon(
      onPressed: () {
        taskViewModel.setSelectedCategory(isSelected ? null : categoryName);
      },
      icon: Icon(icon,
          size: 18, color: isSelected ? colorScheme.onPrimary : color),
      label: Text(
        label,
        style: TextStyle(
          color:
              isSelected ? colorScheme.onPrimary : theme.colorScheme.onSurface,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? color
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    );
  }

  Widget _buildSortButton(
    BuildContext context,
    String label,
    TaskSort sort,
    TaskSort currentSort,
    IconData icon,
    Color iconColor,
  ) {
    final isSelected = sort == currentSort;
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ElevatedButton.icon(
      onPressed: () {
        taskViewModel.setSort(sort);
      },
      icon: Icon(icon,
          size: 18, color: isSelected ? colorScheme.onPrimary : iconColor),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        foregroundColor:
            isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    );
  }
}
