import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waypass_app/core/di/dependency_injection.dart';
import 'package:waypass_app/features/auth/data/token_manager.dart';
import 'package:waypass_app/features/favorite/data/favorite_route_dto.dart';
import 'package:waypass_app/features/travel/domain/travel_route.dart';
import 'package:waypass_app/features/travel/presentation/route_state.dart';
import 'package:waypass_app/features/travel/presentation/route_view_model.dart';
import 'favorite_view_model.dart';
import 'favorite_state.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RouteViewModel>()..loadRoutes(),
      child: const _FavoriteView(),
    );
  }
}

class _FavoriteView extends StatelessWidget {
  const _FavoriteView();

  @override
  Widget build(BuildContext context) {
    final userId = getIt<TokenManager>().getUserId() ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Favoritos',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<FavoriteViewModel, FavoriteState>(
        builder: (context, favoriteState) {
          if (favoriteState is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (favoriteState is FavoriteError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 48,
                        color: Theme.of(context).colorScheme.error),
                    const SizedBox(height: 12),
                    Text(favoriteState.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error)),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context
                          .read<FavoriteViewModel>()
                          .loadFavorites(userId),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (favoriteState is FavoriteLoaded) {
            if (favoriteState.favorites.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_outline,
                          size: 64,
                          color:
                              Theme.of(context).colorScheme.outlineVariant),
                      const SizedBox(height: 16),
                      Text(
                        'No tienes rutas favoritas aún.',
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
                      const SizedBox(height: 8),
                      Text(
                        'Marca rutas como favoritas desde\nla pantalla de viajes.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return BlocBuilder<RouteViewModel, RouteState>(
              builder: (context, routeState) {
                if (routeState is RouteLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final routes = routeState is RouteLoaded
                    ? routeState.routes
                    : <TravelRoute>[];

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<FavoriteViewModel>().loadFavorites(userId);
                    await context.read<RouteViewModel>().loadRoutes();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favoriteState.favorites.length,
                    itemBuilder: (context, index) {
                      final favorite = favoriteState.favorites[index];
                      final route = routes
                          .where((r) => r.id == favorite.routeId)
                          .firstOrNull;
                      return _FavoriteCard(
                        favorite: favorite,
                        route: route,
                        onDelete: () => context
                            .read<FavoriteViewModel>()
                            .removeFavorite(userId, favorite.id),
                      );
                    },
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final FavoriteRouteDto favorite;
  final TravelRoute? route;
  final VoidCallback onDelete;

  const _FavoriteCard({
    required this.favorite,
    required this.route,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final origin = route?.origin;
    final destination = route?.destination;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (origin != null && origin.imageUrl.isNotEmpty)
            SizedBox(
              height: 120,
              width: double.infinity,
              child: Image.network(
                origin.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildPlaceholderImage(),
              ),
            )
          else
            SizedBox(height: 120, child: _buildPlaceholderImage()),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            origin?.name ?? 'Ruta #${favorite.routeId}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          if (destination != null) ...[
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
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline),
                      color: theme.colorScheme.error,
                      tooltip: 'Eliminar de favoritos',
                    ),
                  ],
                ),
                if (route != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 18,
                                color: theme.colorScheme.primary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                origin?.address ?? '',
                                style: theme.textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time_filled,
                              size: 18,
                              color: theme.colorScheme.primary),
                          const SizedBox(width: 6),
                          Text('${route!.duration} min',
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'S/ ${route!.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
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
        child: Icon(Icons.directions_bus, size: 40, color: Colors.grey),
      ),
    );
  }
}
