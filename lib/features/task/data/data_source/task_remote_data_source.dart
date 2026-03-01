import 'package:injectable/injectable.dart';
import 'package:tracker_app/features/task/data/model/task_params.dart';
import 'package:tracker_app/utils/common/exceptions.dart';
import 'package:tracker_app/utils/services/api/api.config.dart';
import 'package:tracker_app/utils/services/api/api.service.dart';

import '../model/task_model.dart';

abstract class RemoteDataSource {
  Future<Map<String, dynamic>> getTasks({
    int page = 1,
    int limit = 10,
    String? status,
    String? search,
  });
  Future<TaskModel> getTask(String id);
  Future<TaskModel> createTask(TaskParams params);
  Future<TaskModel> updateTask(String id, TaskParams params);
  Future<TaskModel> toggleTaskStatus(String id);
  Future<void> deleteTask(String id);
}

@LazySingleton(as: RemoteDataSource)
class TaskRemoteDataSourceImpl implements RemoteDataSource {
  @override
  Future<Map<String, dynamic>> getTasks({
    int page = 1,
    int limit = 10,
    String? status,
    String? search,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        'limit': limit,
      };
      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }

      final res = await ApiService.get(
        ApiConfig.getUrl(ApiConfig.task),
        queryParameters: queryParameters,
      );
      if (res['success'] == false) {
        throw Failure(res['message']);
      }
      return res['data'];
    } catch (e) {
      if (e is Failure) {
        rethrow;
      } else {
        throw Failure();
      }
    }
  }

  @override
  Future<TaskModel> getTask(String id) async {
    try {
      final res = await ApiService.get(
        "${ApiConfig.getUrl(ApiConfig.task)}/$id",
      );
      if (res['success'] == false) {
        throw Failure(res['message']);
      }
      return TaskModel.fromJson(res['data']);
    } catch (e) {
      if (e is Failure) {
        rethrow;
      } else {
        throw Failure();
      }
    }
  }

  @override
  Future<TaskModel> createTask(TaskParams params) async {
    try {
      final res = await ApiService.post(
        ApiConfig.getUrl(ApiConfig.task),
        body: params.toJson(),
      );
      if (res['success'] == false) {
        throw Failure(res['message']);
      }
      return TaskModel.fromJson(res['data']);
    } catch (e) {
      if (e is Failure) {
        rethrow;
      } else {
        throw Failure();
      }
    }
  }

  @override
  Future<TaskModel> updateTask(String id, TaskParams params) async {
    try {
      final res = await ApiService.request(
        method: 'PATCH',
        url: "${ApiConfig.getUrl(ApiConfig.task)}/$id",
        body: params.toJson(),
      );
      if (res['success'] == false) {
        throw Failure(res['message']);
      }
      return TaskModel.fromJson(res['data']);
    } catch (e) {
      if (e is Failure) {
        rethrow;
      } else {
        throw Failure();
      }
    }
  }

  @override
  Future<TaskModel> toggleTaskStatus(String id) async {
    try {
      final res = await ApiService.request(
        method: 'PATCH',
        url: "${ApiConfig.getUrl(ApiConfig.toggleTask)}?id=$id",
      );
      if (res['success'] == false) {
        throw Failure(res['message']);
      }
      return TaskModel.fromJson(res['data']);
    } catch (e) {
      if (e is Failure) {
        rethrow;
      } else {
        throw Failure();
      }
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final res = await ApiService.delete(
        "${ApiConfig.getUrl(ApiConfig.task)}/$id",
      );
      if (res['success'] == false) {
        throw Failure(res['message']);
      }
    } catch (e) {
      if (e is Failure) {
        rethrow;
      } else {
        throw Failure();
      }
    }
  }
}
