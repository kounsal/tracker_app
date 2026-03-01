class TaskEntity {
  final int id;
  final String title;
  final String description;
  final String status;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });
}
