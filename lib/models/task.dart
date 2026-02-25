// Priority enum สำหรับระดับความสำคัญ
enum Priority { high, medium, low }

// Task Model
class Task {
  final String id;
  String title;
  String description;
  Priority priority;
  bool isCompleted;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = Priority.medium,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Factory สำหรับสร้าง Task ใหม่พร้อม unique ID
  factory Task.create({
    required String title,
    String description = '',
    Priority priority = Priority.medium,
  }) {
    return Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      priority: priority,
    );
  }

  // copyWith สำหรับ immutable updates
  Task copyWith({
    String? title,
    String? description,
    Priority? priority,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}
