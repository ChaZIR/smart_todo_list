import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_todo_list/core/l10n/app_localizations.dart';
import 'package:smart_todo_list/presentation/view_models/language_view_model.dart';
import 'package:smart_todo_list/presentation/view_models/task_view_model.dart';
import 'package:smart_todo_list/presentation/view_models/theme_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    final languageViewModel = Provider.of<LanguageViewModel>(context);
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

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
              localizations.settings,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    context,
                    localizations.theme,
                    Icons.palette_rounded,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
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
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              themeViewModel.isDarkMode
                                  ? Icons.dark_mode_rounded
                                  : Icons.light_mode_rounded,
                              color: colorScheme.primary,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                themeViewModel.isDarkMode
                                    ? localizations.translate('darkMode')
                                    : localizations.translate('lightMode'),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                themeViewModel.isDarkMode
                                    ? localizations
                                        .translate('darkModeDescription')
                                    : localizations
                                        .translate('lightModeDescription'),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: themeViewModel.isDarkMode,
                          onChanged: (value) {
                            themeViewModel.toggleTheme();
                          },
                          activeThumbColor: colorScheme.primary,
                          inactiveTrackColor:
                              colorScheme.surfaceContainerHighest,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader(
                    context,
                    localizations.language,
                    Icons.language_rounded,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
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
                      children: [
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () {
                              languageViewModel.changeLanguage('ru');
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: languageViewModel.locale.languageCode ==
                                        'ru'
                                    ? colorScheme.primary.withValues(alpha: 0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                border: languageViewModel.locale.languageCode ==
                                        'ru'
                                    ? Border.all(
                                        color: colorScheme.primary
                                            .withValues(alpha: 0.3),
                                        width: 1,
                                      )
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: languageViewModel
                                                  .locale.languageCode ==
                                              'ru'
                                          ? colorScheme.primary
                                              .withValues(alpha: 0.2)
                                          : colorScheme.surfaceContainerHighest
                                              .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '🇷🇺',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Русский',
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Russian',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (languageViewModel.locale.languageCode ==
                                      'ru')
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: colorScheme.primary,
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () {
                              languageViewModel.changeLanguage('en');
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: languageViewModel.locale.languageCode ==
                                        'en'
                                    ? colorScheme.primary.withValues(alpha: 0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                border: languageViewModel.locale.languageCode ==
                                        'en'
                                    ? Border.all(
                                        color: colorScheme.primary
                                            .withValues(alpha: 0.3),
                                        width: 1,
                                      )
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: languageViewModel
                                                  .locale.languageCode ==
                                              'en'
                                          ? colorScheme.primary
                                              .withValues(alpha: 0.2)
                                          : colorScheme.surfaceContainerHighest
                                              .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '🇬🇧',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'English',
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Английский',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (languageViewModel.locale.languageCode ==
                                      'en')
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: colorScheme.primary,
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader(
                    context,
                    localizations.translate('statistics'),
                    Icons.insights_rounded,
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
                      children: [
                        _buildStatItem(
                          context,
                          localizations.translate('totalTasks'),
                          taskViewModel.totalTasks.toString(),
                          Icons.list_alt_rounded,
                          colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        _buildStatItem(
                          context,
                          localizations.translate('completedTasks'),
                          taskViewModel.completedTasks.toString(),
                          Icons.check_circle_rounded,
                          Colors.green,
                        ),
                        const SizedBox(height: 16),
                        _buildStatItem(
                          context,
                          localizations.translate('pendingTasks'),
                          taskViewModel.pendingTasks.toString(),
                          Icons.pending_actions_rounded,
                          Colors.orange,
                        ),
                        const SizedBox(height: 16),
                        _buildStatItem(
                          context,
                          localizations.translate('overdueCount'),
                          taskViewModel.overdueTasks.toString(),
                          Icons.warning_rounded,
                          Colors.red,
                        ),
                        const SizedBox(height: 16),
                        _buildStatItem(
                          context,
                          localizations.translate('favorites'),
                          taskViewModel.favoriteTasks.toString(),
                          Icons.star_rounded,
                          Colors.amber,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
