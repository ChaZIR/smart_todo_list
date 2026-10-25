import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_todo_list/core/l10n/app_localizations.dart';
import 'package:smart_todo_list/presentation/screens/add_edit_task_screen.dart';
import 'package:smart_todo_list/presentation/screens/favorites_screen.dart';
import 'package:smart_todo_list/presentation/screens/settings_screen.dart';
import 'package:smart_todo_list/presentation/screens/task_detail_screen.dart';
import 'package:smart_todo_list/presentation/view_models/task_view_model.dart';
import 'package:smart_todo_list/presentation/widgets/empty_state.dart';
import 'package:smart_todo_list/presentation/widgets/task_card.dart';
import 'package:smart_todo_list/presentation/widgets/task_filters.dart';
import 'package:smart_todo_list/presentation/widgets/task_statistics_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    if (_showFilters) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (_animationController.isAnimating) return;

      if (_showFilters) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final taskViewModel = Provider.of<TaskViewModel>(context);
    final tasks = taskViewModel.tasks;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
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
              localizations.appTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            centerTitle: false,
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            actions: [
              _buildActionButton(
                context,
                Icons.star_outline,
                localizations.translate('favorites'),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                },
                colorScheme.primary,
              ),
              _buildActionButton(
                context,
                Icons.insights_outlined,
                localizations.translate('statistics'),
                () => _showStatistics(context),
                colorScheme.secondary,
              ),
              _buildActionButton(
                context,
                Icons.settings_outlined,
                localizations.translate('settings'),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                colorScheme.tertiary,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: localizations.search,
                  hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            taskViewModel.setSearchQuery('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: colorScheme.primary.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                ),
                style: TextStyle(color: colorScheme.onSurface),
                onChanged: (value) {
                  taskViewModel.setSearchQuery(value);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ElevatedButton.icon(
                onPressed: _toggleFilters,
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: _animationController,
                  size: 20,
                ),
                label: Text(
                  _showFilters
                      ? localizations.translate('hideFilters')
                      : localizations.translate('showFilters'),
                  style: theme.textTheme.labelLarge,
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              child:
                  _showFilters ? const TaskFilters() : const SizedBox.shrink(),
            ),
          ),
          if (tasks.isNotEmpty)
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
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tasks.length.toString(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (tasks.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: EmptyState(
                    title: localizations.noTasks,
                    description: localizations.noTasksDescription,
                    icon: Icons.task_alt_rounded,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 80),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final task = tasks[index];
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
                  childCount: tasks.length,
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
              builder: (context) => const AddEditTaskScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(localizations.addTask),
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

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String tooltip,
    VoidCallback onPressed,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: IconButton.filledTonal(
        onPressed: onPressed,
        icon: Icon(icon),
        tooltip: tooltip,
        style: IconButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.1),
          foregroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showStatistics(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TaskStatisticsSheet(),
    );
  }
}
