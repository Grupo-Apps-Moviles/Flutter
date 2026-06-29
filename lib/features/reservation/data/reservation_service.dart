import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waypass_app/core/config/api_config.dart';
import 'package:waypass_app/features/auth/data/token_manager.dart';
import 'create_reservation_request.dart';
import 'reservation_dto.dart';

class ReservationService {
  final TokenManager tokenManager;

  final String _baseUrl = '${ApiConfig.baseUrl}/reservations';

  ReservationService({required this.tokenManager});

  Future<void> createReservation(CreateReservationRequest request) async {
    final token = tokenManager.getToken() ?? '';

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error creando reserva: ${response.body}');
    }
  }

  Future<String> getUsernameById(int userId) async {
    final token = tokenManager.getToken() ?? '';

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/Users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return json['username'] as String? ?? 'Desconocido';
    } else {
      throw Exception('Error al obtener usuario ($userId)');
    }
  }

  Future<List<ReservationDto>> getUserReservations(int userId) async {
    final token = tokenManager.getToken() ?? '';

    final response = await http.get(
      Uri.parse('$_baseUrl/user/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error obteniendo reservas: ${response.body}');
    }

    final List<dynamic> jsonList =
    jsonDecode(response.body) as List<dynamic>;

    return jsonList
        .map((e) => ReservationDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}