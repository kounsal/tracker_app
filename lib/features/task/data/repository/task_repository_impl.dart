import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tracker_app/features/task/data/data_source/task_remote_data_source.dart';
import 'package:tracker_app/features/task/data/model/get_tasks_response_model.dart';
import 'package:tracker_app/features/task/data/model/task_params.dart';
import 'package:tracker_app/features/task/domain/entity/get_tasks_response_entity.dart';
import 'package:tracker_app/features/task/domain/entity/task_entity.dart';
import 'package:tracker_app/features/task/domain/repository/task_repository.dart';
import 'package:tracker_app/utils/common/exceptions.dart';

@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final RemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, GetTasksResponseEntity>> getTasks({
    int page = 1,
    int limit = 10,
    String? status,
    String? search,
  }) async {
    try {
      final responseMap = await remoteDataSource.getTasks(
        page: page,
        limit: limit,
        status: status,
        search: search,
      );
      final responseModel = GetTasksResponseModel.fromJson(responseMap);
      return Right(responseModel.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> getTask(String id) async {
    try {
      final res = await remoteDataSource.getTask(id);
      return Right(res.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskParams params) async {
    try {
      final res = await remoteDataSource.createTask(params);
      return Right(res.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(
    String id,
    TaskParams params,
  ) async {
    try {
      final res = await remoteDataSource.updateTask(id, params);
      return Right(res.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> toggleTaskStatus(String id) async {
    try {
      final res = await remoteDataSource.toggleTaskStatus(id);
      return Right(res.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(String id) async {
    try {
      await remoteDataSource.deleteTask(id);
      return const Right(unit);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
