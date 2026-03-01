import 'package:injectable/injectable.dart';
import 'package:tracker_app/utils/common/exceptions.dart';
import 'package:tracker_app/utils/services/api/api.config.dart';
import 'package:tracker_app/utils/services/api/api.service.dart';

import '../../../data/model/user_model.dart';
import 'model/auth_response_model.dart';
import 'model/auth_params.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequestModel request);
  Future<AuthResponseModel> register(RegisterRequestModel request);
  Future<String> refreshToken(String refreshToken);
  Future<UserModel> fetchProfile();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl();

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await ApiService.post(
        ApiConfig.getUrl(ApiConfig.login),
        body: request.toJson(),
      );
      if (response['success']) {
        return AuthResponseModel.fromJson(response['data']);
      } else {
        throw Failure(response['message']);
      }
    } catch (e) {
      if (e is Failure) {
        rethrow;
      } else {
        throw Failure();
      }
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    try {
      final response = await ApiService.post(
        ApiConfig.getUrl(ApiConfig.refreshToken),
        body: {'refreshToken': refreshToken},
      );
      if (response['success']) {
        return response['data']['accessToken'];
      } else {
        throw Failure(response['message']);
      }
    } catch (e) {
      if (e is Failure) {
        rethrow;
      } else {
        throw Failure();
      }
    }
  }

  @override
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await ApiService.post(
        ApiConfig.getUrl(ApiConfig.register),
        body: request.toJson(),
      );
      if (response['success']) {
        return AuthResponseModel.fromJson(response['data']);
      } else {
        throw Failure(response['message']);
      }
    } catch (e) {
      if (e is Failure) {
        rethrow;
      } else {
        throw Failure();
      }
    }
  }

  @override
  Future<UserModel> fetchProfile() async {
    try {
      final response = await ApiService.get(
        ApiConfig.getUrl(ApiConfig.profile),
      );
      if (response['success']) {
        return UserModel.fromJson(response['data']);
      } else {
        throw Failure(response['message']);
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
