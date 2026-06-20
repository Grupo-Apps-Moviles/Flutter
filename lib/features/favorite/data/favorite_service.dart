import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waypass_app/core/config/api_config.dart';
import 'package:waypass_app/features/auth/data/token_manager.dart';
import 'create_favorite_request.dart';
import 'favorite_route_dto.dart';

class FavoriteService {
  final TokenManager tokenManager;
  final String _baseUrl = '${ApiConfig.baseUrl}/favorite-routes';

  FavoriteService({required this.tokenManager});

  Future<FavoriteRouteDto> createFavorite(CreateFavoriteRequest request) async {
    final token = tokenManager.getToken() ?? '';

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return FavoriteRouteDto.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Error al agregar favorito (${response.statusCode})');
    }
  }

  Future<List<FavoriteRouteDto>> getPassengerFavorites(
      int passengerId) async {
    final token = tokenManager.getToken() ?? '';

    final response = await http.get(
      Uri.parse('$_baseUrl/passenger/$passengerId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList
          .map((e) => FavoriteRouteDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al obtener favoritos (${response.statusCode})');
    }
  }

  Future<void> deleteFavorite(int favoriteRouteId) async {
    final token = tokenManager.getToken() ?? '';

    final response = await http.delete(
      Uri.parse('$_baseUrl/$favoriteRouteId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar favorito (${response.statusCode})');
    }
  }
}
