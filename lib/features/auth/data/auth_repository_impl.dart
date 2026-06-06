import 'package:waypass_app/features/auth/data/auth_service.dart';
import 'package:waypass_app/features/auth/data/sign_in_request_dto.dart';
import 'package:waypass_app/features/auth/data/sign_up_request_dto.dart';
import 'package:waypass_app/features/auth/domain/auth_repository.dart';
import 'package:waypass_app/features/auth/domain/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService service;

  const AuthRepositoryImpl({required this.service});

  @override
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final requestDto = SignInRequestDto(email: email, password: password);
    final responseDto = await service.signIn(requestDto);
    return responseDto?.toDomain();
  }

  @override
  Future<User?> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final requestDto = SignUpRequestDto(
      username: username,
      email: email,
      password: password,
    );
    final responseDto = await service.signUp(requestDto);
    return responseDto?.toDomain();
  }
}