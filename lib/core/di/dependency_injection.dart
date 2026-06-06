import 'package:get_it/get_it.dart';
import 'package:waypass_app/features/auth/data/auth_repository_impl.dart';
import 'package:waypass_app/features/auth/data/auth_service.dart';
import 'package:waypass_app/features/auth/domain/auth_repository.dart';
import 'package:waypass_app/features/auth/presentation/login_view_model.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<AuthService>(() => AuthService());

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(service: getIt<AuthService>()),
  );

  getIt.registerFactory(
    () => LoginViewModel(repository: getIt<AuthRepository>()),
  );
}