import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- FEATURE: AUTH ---
import 'package:waypass_app/features/auth/data/auth_repository_impl.dart';
import 'package:waypass_app/features/auth/data/auth_service.dart';
import 'package:waypass_app/features/auth/data/token_manager.dart';
import 'package:waypass_app/features/auth/domain/auth_repository.dart';
import 'package:waypass_app/features/auth/presentation/login_view_model.dart';

// --- FEATURE: PROFILE ---
import 'package:waypass_app/features/profile/data/profile_repository_impl.dart';
import 'package:waypass_app/features/profile/domain/profile_repository.dart';
import 'package:waypass_app/features/profile/presentation/profile_view_model.dart';

// --- FEATURE: TRAVEL ---
import 'package:waypass_app/features/travel/data/route_repository_impl.dart';
import 'package:waypass_app/features/travel/data/route_service.dart';
import 'package:waypass_app/features/travel/domain/route_repository.dart';
import 'package:waypass_app/features/travel/presentation/route_view_model.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // =========================================================================
  // 1. CORE & CACHE LOCAL
  // =========================================================================
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<TokenManager>(() => TokenManager(sharedPreferences));

  // =========================================================================
  // 2. DATA SOURCES (Servicios API externos)
  // =========================================================================
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<RouteService>(() => RouteService(tokenManager: getIt<TokenManager>()));

  // =========================================================================
  // 3. REPOSITORIOS (Lógica de acceso a datos)
  // =========================================================================
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(service: getIt<AuthService>()),
  );
  
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(tokenManager: getIt<TokenManager>()),
  );
  
  getIt.registerLazySingleton<RouteRepository>(
    () => RouteRepositoryImpl(service: getIt<RouteService>()),
  );

  // =========================================================================
  // 4. VIEW MODELS / CUBITS (Gestión de estado de la UI)
  // Nota: Usamos registerFactory para que se cree una instancia nueva 
  // cada vez que se abre la pantalla correspondiente.
  // =========================================================================
  getIt.registerFactory(
    () => LoginViewModel(
      repository: getIt<AuthRepository>(),
      tokenManager: getIt<TokenManager>(),
    ),
  );
  
  getIt.registerFactory(
    () => ProfileViewModel(repository: getIt<ProfileRepository>()),
  );

  getIt.registerFactory(
    () => RouteViewModel(repository: getIt<RouteRepository>()),
  );
}