import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tracker_app/utils/common/exceptions.dart';
import 'package:tracker_app/data/entity/user_entity.dart';

import '../../../../features/auth/data/auth_remote_data_source.dart';
import '../../../../features/auth/data/model/auth_params.dart';
import '../../../../features/auth/domain/entity/auth_response_entity.dart';
import '../../../../features/auth/domain/repository/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AuthResponseEntity>> login(
    LoginRequestModel request,
  ) async {
    try {
      final response = await remoteDataSource.login(request);
      return Right(response.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> register(
    RegisterRequestModel request,
  ) async {
    try {
      final response =await remoteDataSource.register(request);
      return Right(response.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken(String refreshToken) async {
    try {
      final response = await remoteDataSource.refreshToken(refreshToken);
      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> fetchProfile() async {
    try {
      final response = await remoteDataSource.fetchProfile();
      return Right(response.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
