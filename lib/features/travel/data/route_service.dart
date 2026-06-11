import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:waypass_app/features/auth/data/token_manager.dart';
import 'package:waypass_app/features/travel/data/travel_route_dto.dart';

class RouteService {
  final TokenManager tokenManager;
  final String _baseUrl = 'http://10.0.2.2:5191/api/Routes';

  RouteService({required this.tokenManager});

  Future<List<TravelRouteDto>> getAllRoutes() async {
    final uri = Uri.parse(_baseUrl);
    final token = tokenManager.getToken() ?? '';

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => TravelRouteDto.fromJson(json)).toList();
    } else {
      throw Exception('Error del servidor al obtener rutas (${response.statusCode})');
    }
  }
}