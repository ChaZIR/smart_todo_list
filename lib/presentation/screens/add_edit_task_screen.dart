import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_todo_list/core/l10n/app_localizations.dart';
import 'package:smart_todo_list/core/utils/date_helper.dart';
import 'package:smart_todo_list/domain/models/task.dart';
import 'package:smart_todo_list/presentation/models/task_category.dart';
import 'package:smart_todo_list/presentation/view_models/language_view_model.dart';
import 'package:smart_todo_list/presentation/view_models/task_view_model.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagController;

  String? _selectedCategory;
  DateTime? _selectedDeadline;
  List<String> _tags = [];

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _tagController = TextEditingController();
    _selectedCategory = widget.task?.category;
    _selectedDeadline = widget.task?.deadline;
    _tags = List.from(widget.task?.tags ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    Provider.of<TaskViewModel>(context, listen: false);
    final languageViewModel = Provider.of<LanguageViewModel>(context);
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
              isEditing ? localizations.editTask : localizations.addTask,
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
              if (isEditing)
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      context,
                      localizations.taskTitle,
                      Icons.title_rounded,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                      ),
                      child: TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: localizations.translate('enterTitle'),
                          hintStyle: TextStyle(
                            color: colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.red.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.red.withValues(alpha: 0.5),
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: colorScheme.outline.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return localizations.translate('titleRequired');
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      context,
                      localizations.taskDescription,
                      Icons.description_rounded,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                      ),
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: localizations.translate('enterDescription'),
                          hintStyle: TextStyle(
                            color: colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: colorScheme.outline.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      context,
                      localizations.category,
                      Icons.category_rounded,
                    ),
                    SizedBox(
                      height: 56,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildCategoryChip(
                            context,
                            localizations.translate('noCategory'),
                            null,
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
                                category.icon,
                                category.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      context,
                      localizations.deadline,
                      Icons.calendar_today_rounded,
                    ),
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () => _selectDeadline(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _selectedDeadline != null
                                  ? colorScheme.primary.withValues(alpha: 0.3)
                                  : colorScheme.outline.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: _selectedDeadline != null
                                      ? colorScheme.primary
                                          .withValues(alpha: 0.1)
                                      : colorScheme.surfaceContainerHighest
                                          .withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.calendar_today_rounded,
                                    color: _selectedDeadline != null
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant,
                                    size: 22,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      localizations.deadline,
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    Text(
                                      _selectedDeadline != null
                                          ? DateHelper.formatDateTime(
                                              _selectedDeadline!,
                                              languageViewModel
                                                  .locale.languageCode,
                                            )
                                          : localizations.translate('notSet'),
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        color: _selectedDeadline != null
                                            ? colorScheme.onSurface
                                            : colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_selectedDeadline != null)
                                IconButton(
                                  icon: Icon(
                                    Icons.clear_rounded,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedDeadline = null;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      context,
                      localizations.tags,
                      Icons.tag_rounded,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _tagController,
                                    decoration: InputDecoration(
                                      hintText:
                                          localizations.translate('enterTag'),
                                      hintStyle: TextStyle(
                                        color: colorScheme.onSurfaceVariant
                                            .withValues(alpha: 0.6),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: colorScheme.onSurface,
                                    ),
                                    onSubmitted: (value) => _addTag(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton.filledTonal(
                                  onPressed: _addTag,
                                  icon: const Icon(Icons.add_rounded),
                                  style: IconButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    foregroundColor: colorScheme.onPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_tags.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _tags.map((tag) {
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
                                        const SizedBox(width: 4),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _tags.remove(tag);
                                            });
                                          },
                                          child: Icon(
                                            Icons.close_rounded,
                                            size: 14,
                                            color: colorScheme.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isEditing
                                ? Icons.save_rounded
                                : Icons.add_task_rounded,
                            size: 24,
                            color: colorScheme.onPrimary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            localizations.save,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
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

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    String? categoryName,
    IconData icon,
    Color color,
  ) {
    final isSelected = categoryName == _selectedCategory;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          _selectedCategory = isSelected ? null : categoryName;
        });
      },
      icon: Icon(
        icon,
        size: 18,
        color: isSelected ? colorScheme.onPrimary : color,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? color
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

  Future<void> _selectDeadline(BuildContext context) async {
    Provider.of<LanguageViewModel>(context, listen: false);
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final lastDate = firstDate.add(const Duration(days: 365));
    final selected = _selectedDeadline ?? now;
    final initialDate = selected.isBefore(firstDate)
        ? firstDate
        : selected.isAfter(lastDate)
            ? lastDate
            : selected;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogThemeData(
                backgroundColor: Theme.of(context).colorScheme.surface),
          ),
          child: child!,
        );
      },
    );

    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              dialogTheme: DialogThemeData(
                  backgroundColor: Theme.of(context).colorScheme.surface),
            ),
            child: child!,
          );
        },
      );

      if (time != null && mounted) {
        setState(() {
          _selectedDeadline = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    AppLocalizations.of(context);
    Theme.of(context);

    if (isEditing) {
      final updatedTask = widget.task!.copyWith(
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        deadline: _selectedDeadline,
        tags: _tags,
        clearCategory: _selectedCategory == null,
        clearDeadline: _selectedDeadline == null,
      );
      await taskViewModel.updateTask(updatedTask);
    } else {
      final newTask = taskViewModel.createNewTask(
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        deadline: _selectedDeadline,
        tags: _tags,
      );
      await taskViewModel.addTask(newTask);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
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
              final taskViewModel =
                  Provider.of<TaskViewModel>(context, listen: false);
              await taskViewModel.deleteTask(widget.task!.id);
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
