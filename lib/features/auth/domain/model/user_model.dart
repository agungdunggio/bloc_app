import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.token,
  });

  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String token;

  @override
  List<Object?> get props => [id, username, firstName, lastName, token];
}
