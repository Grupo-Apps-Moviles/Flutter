class SignUpRequestDto {
  final String username;
  final String email;
  final String password;
  final int role;

  const SignUpRequestDto({
    required this.username,
    required this.email,
    required this.password,
    this.role = 0,    // valor por defecto — siempre usuario normal
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}