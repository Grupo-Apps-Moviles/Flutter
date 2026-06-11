import 'package:waypass_app/features/travel/data/route_service.dart';
import 'package:waypass_app/features/travel/domain/route_repository.dart';
import 'package:waypass_app/features/travel/domain/travel_route.dart';

class RouteRepositoryImpl implements RouteRepository {
  final RouteService service;

  const RouteRepositoryImpl({required this.service});

  @override
  Future<List<TravelRoute>> getAllRoutes() async {
    final dtos = await service.getAllRoutes();
    // Convertimos la lista de TravelRouteDto a TravelRoute
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}