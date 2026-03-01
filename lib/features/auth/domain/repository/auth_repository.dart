import 'package:dartz/dartz.dart';
import 'package:tracker_app/utils/common/exceptions.dart';
import 'package:tracker_app/features/auth/data/model/auth_params.dart';
import 'package:tracker_app/features/auth/domain/entity/auth_response_entity.dart';

import '../../../../data/entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponseEntity>> login(LoginRequestModel request);
  Future<Either<Failure, AuthResponseEntity>> register(
    RegisterRequestModel request,
  );
  Future<Either<Failure, String>> refreshToken(String refreshToken);
  Future<Either<Failure, UserEntity>> fetchProfile();
}
