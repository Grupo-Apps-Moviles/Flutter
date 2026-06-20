import '../data/favorite_route_dto.dart';

sealed class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<FavoriteRouteDto> favorites;

  FavoriteLoaded({required this.favorites});

  Set<int> get favoriteRouteIds => favorites.map((f) => f.routeId).toSet();
}

class FavoriteError extends FavoriteState {
  final String message;

  FavoriteError({required this.message});
}
