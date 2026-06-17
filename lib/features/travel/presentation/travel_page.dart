import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waypass_app/core/di/dependency_injection.dart';
import 'package:waypass_app/features/reservation/presentation/create_reservation_page.dart';
import 'package:waypass_app/features/travel/domain/travel_route.dart';
import 'package:waypass_app/features/travel/presentation/route_state.dart';
import 'package:waypass_app/features/travel/presentation/route_view_model.dart';

class TravelPage extends StatelessWidget {
  const TravelPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Rutas Disponibles',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 48,
                        color: Theme.of(context).colorScheme.error),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is RouteLoaded) {
            if (state.routes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_bus_filled_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay ninguna ruta disponible.',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<RouteViewModel>().loadRoutes(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.routes.length,
                itemBuilder: (context, index) {
                  return _TravelRouteCard(route: state.routes[index]);
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
    final origin = route.origin;
    final destination = route.destination;

    if (origin == null || destination == null) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      clipBehavior: Clip.antiAlias,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      shadowColor: Colors.black26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 180,
            width: double.infinity,
            child: origin.imageUrl.isNotEmpty
                ? Image.network(
              origin.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _buildPlaceholderImage(),
            )
                : _buildPlaceholderImage(),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  origin.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.grey[700]),
                    children: [
                      const TextSpan(
                        text: 'Destino: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      TextSpan(text: destination.name),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 18,
                              color: theme.colorScheme.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              origin.address,
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.access_time_filled,
                              size: 18,
                              color: theme.colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            '${route.duration} min',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'S/ ${route.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                CreateReservationPage(route: route),
                          ),
                        );
                      },
                      child: const Text('Reservar',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: const Color(0xFFE1E4E8),
      child: const Center(
        child:
        Icon(Icons.directions_bus, size: 48, color: Colors.grey),
      ),
    );
  }
}