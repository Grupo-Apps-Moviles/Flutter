import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waypass_app/features/auth/data/auth_repository_impl.dart';
import 'package:waypass_app/features/auth/data/auth_service.dart';
import 'package:waypass_app/features/auth/data/token_manager.dart';
import 'package:waypass_app/features/auth/domain/auth_repository.dart';
import 'package:waypass_app/features/auth/presentation/login_view_model.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // 1. Inicializamos SharedPreferences y TokenManager
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<TokenManager>(() => TokenManager(sharedPreferences));

  // 2. Data Sources
  getIt.registerLazySingleton<AuthService>(() => AuthService());

  // 3. Repositorios
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(service: getIt<AuthService>()),
  );

  // 4. ViewModels (Cubits)
  getIt.registerFactory(
    () => LoginViewModel(
      repository: getIt<AuthRepository>(),
      tokenManager: getIt<TokenManager>(),
    ),
  );
}