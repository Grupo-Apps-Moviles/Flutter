import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:waypass_app/features/auth/data/token_manager.dart';
import 'package:waypass_app/features/travel/data/travel_route_dto.dart';

class RouteService {
  final TokenManager tokenManager;
  // Recuerda mantener el 10.0.2.2 para el emulador de Android
  final String _baseUrl = 'http://10.0.2.2:5191/api/Routes'; // <-- Ajusta el endpoint si es distinto

  RouteService({required this.tokenManager});

  Future<List<TravelRouteDto>> getAllRoutes() async {
    final uri = Uri.parse(_baseUrl);
    
    // Obtenemos el token guardado en caché
    final token = tokenManager.getToken() ?? '';

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Autenticación de la API
      },
    );

    if (response.statusCode == HttpStatus.ok) {
      // Tu endpoint devuelve una lista JSON: [ { ... }, { ... } ]
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => TravelRouteDto.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las rutas: ${response.statusCode}');
    }
  }
}