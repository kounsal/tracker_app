import '../../domain/entity/task_entity.dart';

class TaskModel {
  final int id;
  final String title;
  final String description;
  final String status;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      userId: json['userId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      status: status,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
