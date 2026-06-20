import '../data/create_favorite_request.dart';
import '../data/favorite_route_dto.dart';
import '../data/favorite_service.dart';
import '../domain/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteService service;

  FavoriteRepositoryImpl({required this.service});

  @override
  Future<FavoriteRouteDto> createFavorite(CreateFavoriteRequest request) {
    return service.createFavorite(request);
  }

  @override
  Future<List<FavoriteRouteDto>> getPassengerFavorites(int passengerId) {
    return service.getPassengerFavorites(passengerId);
  }

  @override
  Future<void> deleteFavorite(int favoriteRouteId) {
    return service.deleteFavorite(favoriteRouteId);
  }
}
