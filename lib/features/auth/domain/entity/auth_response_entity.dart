import '../../../../data/entity/user_entity.dart';

class AuthResponseEntity {
  final UserEntity user;
  final String accessToken;
  final String refreshToken;

  AuthResponseEntity({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });
}
