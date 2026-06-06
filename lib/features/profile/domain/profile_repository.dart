import 'package:waypass_app/features/profile/domain/user_profile.dart';

abstract class ProfileRepository {
  
  /// Recupera los datos del perfil del usuario autenticado.
  Future<UserProfile> getUserProfile();

  /// Cierra la sesión activa del usuario y limpia las credenciales almacenadas.
  Future<void> logout();
}