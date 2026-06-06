class AuthService {
  final String _baseUrl =
      'https://TU-BACKEND.com/api/authentication';

  // POST /api/authentication/sign-in
  Future<AuthResponseDto?> signIn(SignInRequestDto requestDto) async {
    final uri = Uri.parse('$_baseUrl/sign-in');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestDto.toJson()),
    );

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body);
      return AuthResponseDto.fromJson(json);
    }

    return null;
  }

  // POST /api/authentication/sign-up
  Future<AuthResponseDto?> signUp(SignUpRequestDto requestDto) async {
    final uri = Uri.parse('$_baseUrl/sign-up');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestDto.toJson()),
    );

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      final json = jsonDecode(response.body);
      return AuthResponseDto.fromJson(json);
    }

    return null;
  }
}