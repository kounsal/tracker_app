import '../entity/user_entity.dart';

class UserModel {
  final int id;
  final String email;
  final String name;

  UserModel({required this.id, required this.email, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], email: json['email'], name: json['name']);
  }

  UserEntity toEntity() {
    return UserEntity(id: id, email: email, name: name);
  }
}
