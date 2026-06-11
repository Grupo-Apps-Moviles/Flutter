import 'package:waypass_app/features/travel/domain/stop.dart';

class TravelRoute {
  final int id;
  final double price; // Mapeado a double por si el precio tiene decimales
  final int duration; // Asumimos que viene en minutos según tu JSON
  final List<Stop> stops;

  const TravelRoute({
    required this.id,
    required this.price,
    required this.duration,
    required this.stops,
  });
}