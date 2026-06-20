import '../data/create_favorite_request.dart';
import '../data/favorite_route_dto.dart';

abstract class FavoriteRepository {
  Future<FavoriteRouteDto> createFavorite(CreateFavoriteRequest request);

  Future<List<FavoriteRouteDto>> getPassengerFavorites(int passengerId);

  Future<void> deleteFavorite(int favoriteRouteId);
}
