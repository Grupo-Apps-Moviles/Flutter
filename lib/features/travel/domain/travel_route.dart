import 'package:waypass_app/features/travel/domain/stop.dart';

class TravelRoute {
  final int id;
  final double price;
  final int duration;
  final List<Stop> stops;

  const TravelRoute({
    required this.id,
    required this.price,
    required this.duration,
    required this.stops,
  });

  /// Lógica del negocio (Mismo comportamiento que la Web):
  /// El origen siempre es la primera parada de la lista.
  Stop? get origin => stops.isNotEmpty ? stops.first : null;

  /// El destino es la última parada de la lista. Si solo hay una, coincide con el origen.
  Stop? get destination => stops.length > 1 ? stops.last : origin;
}