import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waypass_app/features/auth/data/token_manager.dart';
import 'package:waypass_app/features/auth/domain/auth_repository.dart';
import 'package:waypass_app/features/auth/domain/user.dart';
import 'package:waypass_app/features/auth/presentation/login_state.dart';

class LoginViewModel extends Cubit<LoginState> {
  final AuthRepository repository;
  final TokenManager tokenManager;

  LoginViewModel({
    required this.repository,
    required this.tokenManager,
  }) : super(LoginInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      final User user = await repository.signIn(
        email: email.trim(),
        password: password.trim(),
      );

      // Guardamos los datos en caché local igual que en Kotlin
      await tokenManager.saveToken(user.token);
      await tokenManager.saveUserId(user.id);
      await tokenManager.saveRole(user.role);

      emit(LoginSuccess(user: user));
    } catch (e) {
      emit(LoginFailure(error: _formatError(e)));
    }
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    required String userType, // "Pasajero" o "Conductor"
  }) async {
    emit(LoginLoading());

    try {
      // Equivalente a Kotlin: val role = if (userType == "Conductor") 1 else 0
      final role = (userType == "Conductor") ? 1 : 0;

      await repository.signUp(
        username: username.trim(),
        email: email.trim(),
        password: password.trim(),
        role: role,
      );

      emit(SignUpSuccess());
    } catch (e) {
      emit(LoginFailure(error: _formatError(e)));
    }
  }

  // Pequeña función para limpiar el mensaje de error visualmente
  String _formatError(dynamic e) {
    return e.toString().replaceAll("Exception:", "").trim();
  }
}