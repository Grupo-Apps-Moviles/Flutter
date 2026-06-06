import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waypass_app/core/di/dependency_injection.dart';
import 'package:waypass_app/features/auth/presentation/login_page.dart';
import 'package:waypass_app/features/auth/presentation/login_view_model.dart';
import 'package:waypass_app/features/auth/presentation/register_page.dart';
import 'package:waypass_app/features/main/presentation/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WayPass',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => BlocProvider(
              create: (context) => getIt<LoginViewModel>(),
              child: LoginPage(),
            ),
        '/register': (context) => BlocProvider(
              create: (context) => getIt<LoginViewModel>(),
              child: RegisterPage(), // Registramos la pantalla de registro - succellfull
            ),
        '/main': (context) => const MainPage(),
      },
    );
  }
}