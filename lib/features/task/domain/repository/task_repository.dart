import 'package:dartz/dartz.dart';
import 'package:tracker_app/utils/common/exceptions.dart';
import 'package:tracker_app/features/task/data/model/task_params.dart';
import 'package:tracker_app/features/task/domain/entity/task_entity.dart';
import 'package:tracker_app/features/task/domain/entity/get_tasks_response_entity.dart';

abstract class TaskRepository {
  Future<Either<Failure, GetTasksResponseEntity>> getTasks({
    int page = 1,
    int limit = 10,
    String? status,
    String? search,
  });
  Future<Either<Failure, TaskEntity>> getTask(String id);
  Future<Either<Failure, TaskEntity>> createTask(TaskParams params);
  Future<Either<Failure, TaskEntity>> updateTask(String id, TaskParams params);
  Future<Either<Failure, TaskEntity>> toggleTaskStatus(String id);
  Future<Either<Failure, Unit>> deleteTask(String id);
}
