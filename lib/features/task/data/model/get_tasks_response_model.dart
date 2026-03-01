import '../../domain/entity/get_tasks_response_entity.dart';
import 'task_model.dart';

class PaginationModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }

  PaginationEntity toEntity() {
    return PaginationEntity(
      total: total,
      page: page,
      limit: limit,
      totalPages: totalPages,
    );
  }
}

class GetTasksResponseModel {
  final List<TaskModel> tasks;
  final PaginationModel pagination;

  GetTasksResponseModel({required this.tasks, required this.pagination});

  factory GetTasksResponseModel.fromJson(Map<String, dynamic> json) {
    return GetTasksResponseModel(
      tasks: (json['tasks'] as List)
          .map((task) => TaskModel.fromJson(task))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }

  GetTasksResponseEntity toEntity() {
    return GetTasksResponseEntity(
      tasks: tasks.map((task) => task.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }
}
