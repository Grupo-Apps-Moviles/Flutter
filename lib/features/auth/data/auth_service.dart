import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:waypass_app/features/auth/data/auth_response_dto.dart';
import 'package:waypass_app/features/auth/data/sign_in_request_dto.dart';
import 'package:waypass_app/features/auth/data/sign_up_request_dto.dart';

class AuthService {
  // Nota: Si pruebas en emulador Android, localhost es 10.0.2.2
  final String _baseUrl = 'http://10.0.2.2:5191/api/Authentication';

  Future<AuthResponseDto> signIn(SignInRequestDto requestDto) async {
    final uri = Uri.parse('$_baseUrl/sign-in');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestDto.toJson()),
    );

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body);
      return AuthResponseDto.fromJson(json);
    } else if (response.statusCode == HttpStatus.unauthorized) {
      throw Exception('Correo electrónico o contraseña incorrectos.');
    } else {
      throw Exception('No se pudo iniciar sesión. Inténtalo de nuevo.');
    }
  }

  Future<void> signUp(SignUpRequestDto requestDto) async {
    final uri = Uri.parse('$_baseUrl/sign-up');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestDto.toJson()),
    );

    if (response.statusCode != HttpStatus.ok && response.statusCode != HttpStatus.created) {
      if (response.statusCode == HttpStatus.badRequest) {
        throw Exception('Datos inválidos o el usuario ya existe.');
      }
      throw Exception('No se pudo crear la cuenta. Inténtalo de nuevo.');
    }
  }
}