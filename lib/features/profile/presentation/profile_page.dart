import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waypass_app/core/di/dependency_injection.dart';
import 'package:waypass_app/features/profile/presentation/profile_state.dart';
import 'package:waypass_app/features/profile/presentation/profile_view_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyectamos el Cubit localmente y disparamos la lectura automática de la caché
    return BlocProvider(
      create: (context) => getIt<ProfileViewModel>()..loadProfile(),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileViewModel, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLogoutSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sesión cerrada correctamente'),
                backgroundColor: Colors.green,
              ),
            );

            // Lógica Senior de Seguridad:
            // Al salir, borramos todo el árbol de navegación previo y llevamos al /login.
            // Esto previene que un usuario deslogueado pueda volver atrás con botones físicos.
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileFailure) {
            return Center(
              child: Text(
                'Error al cargar perfil: ${state.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          if (state is ProfileSuccess) {
            final profile = state.profile;
            final String roleName = profile.role == 1
                ? 'Conductor'
                : 'Pasajero';

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar de Usuario con Iniciales o Ícono
                  Center(
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.person_rounded,
                        size: 48,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Tarjeta Contenedora de Datos
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 1.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.account_circle_outlined),
                            title: const Text(
                              'Nombre de usuario',
                              style: TextStyle(fontSize: 13),
                            ),
                            subtitle: Text(
                              profile.username,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          ListTile(
                            leading: const Icon(Icons.email_outlined),
                            title: const Text(
                              'Correo electrónico',
                              style: TextStyle(fontSize: 13),
                            ),
                            subtitle: Text(
                              profile.email,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          ListTile(
                            leading: const Icon(Icons.badge_outlined),
                            title: const Text(
                              'Tipo de Cuenta',
                              style: TextStyle(fontSize: 13),
                            ),
                            subtitle: Text(
                              roleName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Botón de Cierre de Sesión Estilizado
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(
                        double.infinity,
                        50,
                      ), // ancho completo, alto 50
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      context.read<ProfileViewModel>().logout();
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text(
                      'Cerrar sesión',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
