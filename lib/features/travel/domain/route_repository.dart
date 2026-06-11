import 'package:waypass_app/features/travel/domain/travel_route.dart';

abstract class RouteRepository {
  /// Obtiene la lista de todas las rutas de viaje disponibles desde el backend.
  Future<List<TravelRoute>> getAllRoutes();
}