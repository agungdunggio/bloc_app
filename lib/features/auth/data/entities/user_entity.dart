import 'package:bloc_state_management/features/auth/domain/model/user_model.dart';

class UserEntity extends UserModel {
  const UserEntity({
    required super.id,
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.token,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: (json['id'] as num?)?.toInt() ?? 0,
      username: (json['username'] as String?) ?? '',
      firstName: (json['firstName'] as String?) ?? '',
      lastName: (json['lastName'] as String?) ?? '',
      token: (json['accessToken'] as String?) ?? '',
    );
  }
}
