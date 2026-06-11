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
    final stopsList = json['stops'] as List? ?? [];
    final stopsDtoList = stopsList
        .map((stopJson) => StopDto.fromJson(stopJson as Map<String, dynamic>))
        .toList();

    return TravelRouteDto(
      id: json['id'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
      stops: stopsDtoList,
    );
  }

  TravelRoute toDomain() {
    return TravelRoute(
      id: id,
      price: price,
      duration: duration,
      stops: stops.map((dto) => dto.toDomain()).toList(),
    );
  }
}