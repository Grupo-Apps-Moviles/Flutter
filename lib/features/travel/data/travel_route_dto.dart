import 'package:waypass_app/features/travel/data/stop_dto.dart';
import 'package:waypass_app/features/travel/domain/travel_route.dart';

class TravelRouteDto {
  final int id;
  final double price;
  final int duration;
  final List<StopDto> stops;

  const TravelRouteDto({
    required this.id,
    required this.price,
    required this.duration,
    required this.stops,
  });

  factory TravelRouteDto.fromJson(Map<String, dynamic> json) {
    // Parseamos la lista de paradas de forma segura
    var stopsList = json['stops'] as List? ?? [];
    List<StopDto> stopsDtoList = stopsList.map((stopJson) => StopDto.fromJson(stopJson)).toList();

    return TravelRouteDto(
      id: json['id'] ?? 0,
      price: (json['price'] ?? 0).toDouble(), // Aseguramos que sea double
      duration: json['duration'] ?? 0,
      stops: stopsDtoList,
    );
  }

  TravelRoute toDomain() {
    return TravelRoute(
      id: id,
      price: price,
      duration: duration,
      stops: stops.map((stopDto) => stopDto.toDomain()).toList(),
    );
  }
}