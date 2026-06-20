import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/create_favorite_request.dart';
import '../domain/favorite_repository.dart';
import 'favorite_state.dart';

class FavoriteViewModel extends Cubit<FavoriteState> {
  final FavoriteRepository repository;

  FavoriteViewModel({required this.repository}) : super(FavoriteInitial());

  Future<void> loadFavorites(int passengerId) async {
    emit(FavoriteLoading());
    try {
      final favorites = await repository.getPassengerFavorites(passengerId);
      emit(FavoriteLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoriteError(
          message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> toggleFavorite(int passengerId, int routeId) async {
    final currentState = state;
    if (currentState is! FavoriteLoaded) return;

    final existing = currentState.favorites
        .where((f) => f.routeId == routeId)
        .firstOrNull;

    try {
      if (existing != null) {
        await repository.deleteFavorite(existing.id);
      } else {
        await repository.createFavorite(
          CreateFavoriteRequest(passengerId: passengerId, routeId: routeId),
        );
      }
      final favorites = await repository.getPassengerFavorites(passengerId);
      emit(FavoriteLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoriteLoaded(favorites: List.from(currentState.favorites)));
    }
  }

  Future<void> removeFavorite(int passengerId, int favoriteId) async {
    final currentState = state;
    try {
      await repository.deleteFavorite(favoriteId);
      final favorites = await repository.getPassengerFavorites(passengerId);
      emit(FavoriteLoaded(favorites: favorites));
    } catch (e) {
      if (currentState is FavoriteLoaded) {
        emit(FavoriteLoaded(favorites: List.from(currentState.favorites)));
      }
      emit(FavoriteError(
          message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
