import 'package:waypass_app/features/travel/domain/travel_route.dart';

abstract class RouteRepository {
  Future<List<TravelRoute>> getAllRoutes();
}