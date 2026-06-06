import 'package:waypass_app/features/auth/domain/user.dart';

class AuthResponseDto {
  final int id;
  final String username;
  final int role;
  final String token;

  const AuthResponseDto({
    required this.id,
    required this.username,
    required this.role,
    required this.token,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      id: json['id'],
      username: json['username'],
      role: json['role'],
      token: json['token'],
    );
  }

  User toDomain() {
    return User(
      id: id,
      username: username,
      role: role,
      token: token,
    );
  }
}