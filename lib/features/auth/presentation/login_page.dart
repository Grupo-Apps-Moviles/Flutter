import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waypass_app/features/auth/presentation/login_state.dart';
import 'package:waypass_app/features/auth/presentation/login_view_model.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // controladores para sign-in
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // controladores para sign-up
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginViewModel, LoginState>(
        builder: (context, state) {

          // Estado exitoso — muestra el mensaje
          if (state is LoginSuccess) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 64),
                  SizedBox(height: 16),
                  Text(
                    '¡Logrado!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Bienvenido, ${state.user.username}'),
                  SizedBox(height: 4),
                  Text(state.user.email, style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // formularios de login y registro
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                SizedBox(height: 48),

                // --- SIGN IN ---
                Text('Iniciar sesión',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Contraseña',
                  ),
                ),

                // muestra error si falló
                if (state is LoginFailure)
                  Text(state.error, style: TextStyle(color: Colors.red)),

                // muestra spinner si está cargando
                if (state is LoginLoading)
                  Center(child: CircularProgressIndicator())
                else
                  FilledButton(
                    onPressed: () {
                      context.read<LoginViewModel>().signIn(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                    },
                    child: Text('Ingresar'),
                  ),

                Divider(height: 48),

                // --- SIGN UP ---
                Text('Crear cuenta',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Username',
                  ),
                ),
                TextField(
                  controller: _signUpEmailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                  ),
                ),
                TextField(
                  controller: _signUpPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Contraseña',
                  ),
                ),

                if (state is LoginLoading)
                  SizedBox.shrink()
                else
                  OutlinedButton(
                    onPressed: () {
                      context.read<LoginViewModel>().signUp(
                            username: _usernameController.text,
                            email: _signUpEmailController.text,
                            password: _signUpPasswordController.text,
                          );
                    },
                    child: Text('Registrarse'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}