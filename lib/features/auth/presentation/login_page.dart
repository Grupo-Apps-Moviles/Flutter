import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waypass_app/features/auth/presentation/login_state.dart';
import 'package:waypass_app/features/auth/presentation/login_view_model.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginViewModel, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Aquí navegas a tu página principal:
            // Navigator.pushReplacementNamed(context, '/home');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Bienvenido, ${state.user.username}'), backgroundColor: Colors.green),
            );
            // AQUÍ ESTÁ LA MAGIA: 
            // pushReplacementNamed destruye la pantalla de Login y te lleva al Main.
            // Esto evita que el usuario pueda regresar al Login presionando el botón "Atrás" de su celular.
            Navigator.pushReplacementNamed(context, '/main');
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              // Equivalente a Brush.verticalGradient de Jetpack Compose
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Colors.purple[400]!, // Color medio morado
                  Theme.of(context).colorScheme.primaryContainer,
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Iniciar sesión',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Bienvenido de nuevo a WayPass',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Input Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Input Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        // Mostrar error si falla
                        if (state is LoginFailure) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, size: 20, color: Theme.of(context).colorScheme.onErrorContainer),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    state.error,
                                    style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],

                        const SizedBox(height: 24),

                        // Botón de Login
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                            onPressed: state is LoginLoading
                                ? null
                                : () {
                                    context.read<LoginViewModel>().signIn(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );
                                  },
                            child: state is LoginLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text('Ingresar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Botón para ir al registro
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿No tienes cuenta?',
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                            TextButton(
                              onPressed: () {
                                // Aquí navegas a la pantalla de Registro
                                // Navigator.pushNamed(context, '/register');
                              },
                              child: const Text('Regístrate'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}