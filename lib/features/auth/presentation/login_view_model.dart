import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waypass_app/features/auth/domain/auth_repository.dart';
import 'package:waypass_app/features/auth/domain/user.dart';
import 'package:waypass_app/features/auth/presentation/login_state.dart';

class LoginViewModel extends Cubit<LoginState> {
  final AuthRepository repository;

  // super(LoginInitial()) — estado inicial al arrancar
  LoginViewModel({required this.repository}) : super(LoginInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());   // avisa que está cargando

    try {
      final User? user = await repository.signIn(
        email: email,
        password: password,
      );

      if (user != null) {
        emit(LoginSuccess(user: user));   // éxito
      } else {
        emit(LoginFailure(error: 'Correo o contraseña incorrectos'));
      }
    } catch (e) {
      emit(LoginFailure(error: 'Error de conexión: $e'));
    }
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      final User? user = await repository.signUp(
        username: username,
        email: email,
        password: password,
      );

      if (user != null) {
        emit(LoginSuccess(user: user));
      } else {
        emit(LoginFailure(error: 'No se pudo crear la cuenta'));
      }
    } catch (e) {
      emit(LoginFailure(error: 'Error de conexión: $e'));
    }
  }
}