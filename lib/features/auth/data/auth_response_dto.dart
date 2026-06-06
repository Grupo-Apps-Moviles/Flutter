import 'package:waypass_app/features/auth/domain/user.dart';

class AuthResponseDto {
  final String token;
  final String username;
  final String email;

  const AuthResponseDto({
    required this.token,
    required this.username,
    required this.email,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      token:    json['token'],
      username: json['username'],
      email:    json['email'],
    );
  }

  User toDomain() {
    return User(
      username: username,
      email:    email,
    );
  }
}