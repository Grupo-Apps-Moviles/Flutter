import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waypass_app/features/auth/data/auth_repository_impl.dart';
import 'package:waypass_app/features/auth/data/auth_service.dart';
import 'package:waypass_app/features/auth/data/token_manager.dart';
import 'package:waypass_app/features/auth/domain/auth_repository.dart';
import 'package:waypass_app/features/auth/presentation/login_view_model.dart';
import 'package:waypass_app/features/profile/data/profile_repository_impl.dart';
import 'package:waypass_app/features/profile/domain/profile_repository.dart';
import 'package:waypass_app/features/profile/presentation/profile_view_model.dart';
import 'package:waypass_app/features/travel/data/route_repository_impl.dart';
import 'package:waypass_app/features/travel/data/route_service.dart';
import 'package:waypass_app/features/travel/domain/route_repository.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<TokenManager>(() => TokenManager(sharedPreferences));

  // Data Sources
  getIt.registerLazySingleton<AuthService>(() => AuthService());

  // Repositorios
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(service: getIt<AuthService>()),
  );
  // REGISTRO NUEVO DEL REPOSITORIO DE PROFILE
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(tokenManager: getIt<TokenManager>()),
  );

  // ViewModels (Cubits)
  getIt.registerFactory(
    () => LoginViewModel(
      repository: getIt<AuthRepository>(),
      tokenManager: getIt<TokenManager>(),
    ),
  );
  // REGISTRO NUEVO DEL VIEWMODEL DE PROFILE
  getIt.registerFactory(
    () => ProfileViewModel(repository: getIt<ProfileRepository>()),
  );

  // En Data Sources:
  getIt.registerLazySingleton<RouteService>(() => RouteService(tokenManager: getIt<TokenManager>()));

  // En Repositories:
  getIt.registerLazySingleton<RouteRepository>(() => RouteRepositoryImpl(service: getIt<RouteService>()));
}