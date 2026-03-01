import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../utils/common/widgets/common_functions.dart';
import '../../../../utils/common/widgets/snackBar.dart';
import '../../../../utils/theme/theme.extension.dart';
import '../../data/model/task_params.dart';
import '../../domain/entity/get_tasks_response_entity.dart';
import '../../domain/entity/task_entity.dart';
import '../../domain/repository/task_repository.dart';

@LazySingleton()
class TaskProvider extends ChangeNotifier {
  final TaskRepository taskRepository;

  TaskProvider({required this.taskRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<TaskEntity> _tasks = [];
  List<TaskEntity> get tasks => _tasks;

  PaginationEntity? _pagination;
  PaginationEntity? get pagination => _pagination;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> getTasks({
    int page = 1,
    int limit = 10,
    String? status,
    String? search,
  }) async {
    setLoading(true);
    final result = await taskRepository.getTasks(
      page: page,
      limit: limit,
      status: status,
      search: search,
    );
    setLoading(false);

    return result.fold(
      (failure) {
        showSnackbar(failure.message, bContext.colors.error);
        return false;
      },
      (response) {
        if (page == 1) {
          _tasks = response.tasks;
        } else {
          _tasks.addAll(response.tasks);
        }
        _pagination = response.pagination;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> createTask(TaskParams params) async {
    setLoading(true);
    final result = await taskRepository.createTask(params);
    setLoading(false);

    return result.fold(
      (failure) {
        showSnackbar(failure.message, bContext.colors.error);
        return false;
      },
      (task) {
        _tasks.insert(0, task);
        showSnackbar('Task created successfully', bContext.colors.success);
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> updateTask(String id, TaskParams params) async {
    setLoading(true);
    final result = await taskRepository.updateTask(id, params);
    setLoading(false);

    return result.fold(
      (failure) {
        showSnackbar(failure.message, bContext.colors.error);
        return false;
      },
      (task) {
        final index = _tasks.indexWhere((t) => t.id.toString() == id);
        if (index != -1) {
          _tasks[index] = task;
          notifyListeners();
        }
        showSnackbar('Task updated successfully', bContext.colors.success);
        return true;
      },
    );
  }

  Future<bool> toggleTaskStatus(String id) async {
    setLoading(true);
    final result = await taskRepository.toggleTaskStatus(id);
    setLoading(false);

    return result.fold(
      (failure) {
        showSnackbar(failure.message, bContext.colors.error);
        return false;
      },
      (task) {
        final index = _tasks.indexWhere((t) => t.id.toString() == id);
        if (index != -1) {
          _tasks[index] = task;
          notifyListeners();
        }
        return true;
      },
    );
  }

  Future<bool> deleteTask(String id) async {
    setLoading(true);
    final result = await taskRepository.deleteTask(id);
    setLoading(false);

    return result.fold(
      (failure) {
        showSnackbar(failure.message, bContext.colors.error);
        return false;
      },
      (_) {
        _tasks.removeWhere((t) => t.id.toString() == id);
        showSnackbar('Task deleted successfully', bContext.colors.success);
        notifyListeners();
        return true;
      },
    );
  }
}
