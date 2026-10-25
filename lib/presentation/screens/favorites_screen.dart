import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_todo_list/core/l10n/app_localizations.dart';
import 'package:smart_todo_list/presentation/screens/task_detail_screen.dart';
import 'package:smart_todo_list/presentation/view_models/task_view_model.dart';
import 'package:smart_todo_list/presentation/widgets/empty_state.dart';
import 'package:smart_todo_list/presentation/widgets/task_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final taskViewModel = Provider.of<TaskViewModel>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final favoriteTasks =
        taskViewModel.tasks.where((t) => t.isFavorite).toList();

    return Scaffold(
      body: NestedScrollView(
        physics: const ClampingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
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
                localizations.translate('favorites'),
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
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.amber.withValues(alpha: 0.1),
                        Colors.amber.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.2),
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
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.translate('favorites'),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${favoriteTasks.length} ${localizations.translate('tasks')}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.amber.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${((favoriteTasks.length / taskViewModel.totalTasks) * 100).toStringAsFixed(0)}%',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.amber,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (favoriteTasks.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        localizations.translate('tasks'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          favoriteTasks.length.toString(),
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.amber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ];
        },
        body: favoriteTasks.isEmpty
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: EmptyState(
                    title: localizations.translate('noFavorites'),
                    description:
                        localizations.translate('noFavoritesDescription'),
                    icon: Icons.star_outline_rounded,
                    iconColor: Colors.amber,
                    buttonText: localizations.translate('browseTasks'),
                    onButtonPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.only(bottom: 80),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: favoriteTasks.length,
                  itemBuilder: (context, index) {
                    final task = favoriteTasks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TaskCard(
                        task: task,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TaskDetailScreen(task: task),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
