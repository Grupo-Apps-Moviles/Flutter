import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waypass_app/core/di/dependency_injection.dart';
import 'package:waypass_app/features/auth/presentation/login_page.dart';
import 'package:waypass_app/features/auth/presentation/login_view_model.dart';
import 'package:waypass_app/features/main/presentation/main_page.dart';

void main() async {
  // 1. Obligatorio al usar asincronismo antes de runApp (por SharedPreferences)
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Esperamos a que todas las dependencias se inyecten correctamente
  await setup();
  
  // 3. Arrancamos la aplicación
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WayPass',
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de "DEBUG"
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple, // Equivalente a tus colores Purple del proyecto original
          brightness: Brightness.light,
        ),
        // Tipografía por defecto si deseas aplicarla globalmente luego
        // fontFamily: 'Poppins', 
      ),
      // Definimos el login como pantalla inicial
      initialRoute: '/login',
      // Mapeo de rutas de la aplicación
      routes: {
        '/login': (context) => BlocProvider(
              create: (context) => getIt<LoginViewModel>(),
              child: LoginPage(),
            ),
        '/main': (context) => const MainPage(),
      },
    );
  }
}