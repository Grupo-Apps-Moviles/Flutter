import 'package:waypass_app/features/auth/domain/user.dart';

abstract class AuthRepository {
  
  Future<User> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    required int role, 
  });
}