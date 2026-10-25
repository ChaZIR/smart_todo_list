class Task {
  final String id;
  String title;
  String description;
  bool isCompleted;
  bool isFavorite;
  DateTime createdAt;
  DateTime? deadline;
  String? category;
  List<String> tags;
  int? notificationId;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.isFavorite = false,
    required this.createdAt,
    this.deadline,
    this.category,
    List<String>? tags,
    this.notificationId,
  }) : tags = List<String>.of(tags ?? []);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'category': category,
      'tags': tags,
      'notificationId': notificationId,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      notificationId: json['notificationId'] as int?,
    );
  }

  Task copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    bool? isFavorite,
    DateTime? deadline,
    String? category,
    List<String>? tags,
    int? notificationId,
    bool clearDeadline = false,
    bool clearCategory = false,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt,
      deadline: clearDeadline ? null : (deadline ?? this.deadline),
      category: clearCategory ? null : (category ?? this.category),
      tags: tags ?? this.tags,
      notificationId: notificationId ?? this.notificationId,
    );
  }

  bool get isOverdue {
    if (deadline == null || isCompleted) return false;
    return deadline!.isBefore(DateTime.now());
  }

  bool get isDueToday {
    if (deadline == null) return false;
    final now = DateTime.now();
    final deadlineDate = deadline!;
    return now.year == deadlineDate.year &&
        now.month == deadlineDate.month &&
        now.day == deadlineDate.day;
  }
}
