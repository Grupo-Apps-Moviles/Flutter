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

// --- FEATURE: RESERVATION ---
import 'package:waypass_app/features/reservation/data/reservation_repository_impl.dart';
import 'package:waypass_app/features/reservation/data/reservation_service.dart';
import 'package:waypass_app/features/reservation/domain/reservation_repository.dart';
import 'package:waypass_app/features/reservation/presentation/reservation_view_model.dart';

// --- FEATURE: FAVORITE ---
import 'package:waypass_app/features/favorite/data/favorite_repository_impl.dart';
import 'package:waypass_app/features/favorite/data/favorite_service.dart';
import 'package:waypass_app/features/favorite/domain/favorite_repository.dart';
import 'package:waypass_app/features/favorite/presentation/favorite_view_model.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // =========================================================================
  // 1. CORE & CACHE LOCAL
  // =========================================================================
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<TokenManager>(
          () => TokenManager(sharedPreferences));

  // =========================================================================
  // 2. DATA SOURCES
  // =========================================================================
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<RouteService>(
          () => RouteService(tokenManager: getIt<TokenManager>()));
  getIt.registerLazySingleton<ReservationService>(
          () => ReservationService(tokenManager: getIt<TokenManager>()));
  getIt.registerLazySingleton<FavoriteService>(
          () => FavoriteService(tokenManager: getIt<TokenManager>()));

  // =========================================================================
  // 3. REPOSITORIOS
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
  getIt.registerLazySingleton<ReservationRepository>(
        () => ReservationRepositoryImpl(service: getIt<ReservationService>()),
  );
  getIt.registerLazySingleton<FavoriteRepository>(
        () => FavoriteRepositoryImpl(service: getIt<FavoriteService>()),
  );

  // =========================================================================
  // 4. VIEW MODELS / CUBITS
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
  getIt.registerFactory(
        () => ReservationViewModel(repository: getIt<ReservationRepository>()),
  );
  getIt.registerFactory(
        () => FavoriteViewModel(repository: getIt<FavoriteRepository>()),
  );
}