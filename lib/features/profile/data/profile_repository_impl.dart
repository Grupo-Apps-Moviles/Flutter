import 'package:waypass_app/features/auth/data/token_manager.dart';
import 'package:waypass_app/features/profile/domain/profile_repository.dart';
import 'package:waypass_app/features/profile/domain/user_profile.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final TokenManager tokenManager;

  const ProfileRepositoryImpl({required this.tokenManager});

  @override
  Future<UserProfile> getUserProfile() async {
    // Leemos los datos de caché
    final username = tokenManager.getUsername() ?? 'Usuario';
    final email = tokenManager.getEmail() ?? 'correo@waypass.com';
    final role = tokenManager.getRole() ?? 0;

    return UserProfile(
      username: username,
      email: email,
      role: role,
    );
  }

  @override
  Future<void> logout() async {
    // SharedPreferences.clear() elimina todos los datos (token, rol, username, email)
    await tokenManager.clearSession();
  }
}