
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waypass_app/core/di/dependency_injection.dart';
import 'package:waypass_app/features/travel/domain/travel_route.dart';
import 'package:waypass_app/features/travel/presentation/route_state.dart';
import 'package:waypass_app/features/travel/presentation/route_view_model.dart';

class TravelPage extends StatelessWidget {
  const TravelPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyección explícita del Cubit de rutas al instanciar la pantalla
    return BlocProvider(
      create: (context) => getIt<RouteViewModel>()..loadRoutes(),
      child: const TravelView(),
    );
  }
}

class TravelView extends StatelessWidget {
  const TravelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutas Disponibles', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<RouteViewModel, RouteState>(
        builder: (context, state) {
          if (state is RouteLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RouteError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Ocurrió un error al cargar las rutas:\n${state.message}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is RouteLoaded) {
            if (state.routes.isEmpty) {
              return const Center(
                child: Text('No hay rutas de viaje disponibles en este momento.'),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<RouteViewModel>().loadRoutes(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.routes.length,
                itemBuilder: (context, index) {
                  final travelRoute = state.routes[index];
                  return _TravelRouteCard(route: travelRoute);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _TravelRouteCard extends StatelessWidget {
  final TravelRoute route;

  const _TravelRouteCard({required this.route});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Fila superior: Precio y Duración estimada
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'S/ ${route.price.toStringAsFixed(2)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 18, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      '${route.duration} min',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            
            Text('Paradas del viaje:', style: theme.textTheme.titleSmall),
            const SizedBox(height: 10),
            
            // Renderizado dinámico de paradas e imágenes
            ...route.stops.map((stop) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: stop.imageUrl.isNotEmpty 
                      ? Image.network(
                          stop.imageUrl, 
                          width: 60, 
                          height: 60, 
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 60, height: 60, color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        )
                      : Container(
                          width: 60, height: 60, color: theme.colorScheme.primaryContainer,
                          child: Icon(Icons.location_on, color: theme.colorScheme.onPrimaryContainer),
                        ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stop.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          stop.address,
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
            
            const SizedBox(height: 12),
            
            // Botón Reservar: Orquestador de la transición entre módulos
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                // Envía una notificación visual previa al desarrollo del módulo Reservation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Redirigiendo reserva para Ruta ID: ${route.id}...')),
                );
              },
              child: const Text('Reservar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            )
          ],
        ),
      ),
    );
  }
}