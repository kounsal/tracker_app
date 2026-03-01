import 'task_entity.dart';

class PaginationEntity {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationEntity({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });
}

class GetTasksResponseEntity {
  final List<TaskEntity> tasks;
  final PaginationEntity pagination;

  GetTasksResponseEntity({required this.tasks, required this.pagination});
}
