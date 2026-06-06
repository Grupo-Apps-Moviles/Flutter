import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waypass_app/features/profile/domain/profile_repository.dart';
import 'package:waypass_app/features/profile/presentation/profile_state.dart';

class ProfileViewModel extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileViewModel({required this.repository}) : super(ProfileInitial());

  /// Carga los datos guardados en caché local
  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await repository.getUserProfile();
      emit(ProfileSuccess(profile: profile));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  /// Limpia las SharedPreferences y emite éxito de cierre de sesión
  Future<void> logout() async {
    emit(ProfileLoading());
    try {
      await repository.logout();
      emit(ProfileLogoutSuccess());
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }
}