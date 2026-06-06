class UserProfile {
  final String username;
  final String email;
  final int role; // 0 para Pasajero, 1 para Conductor (Manteniendo consistencia con Kotlin)

  const UserProfile({
    required this.username,
    required this.email,
    required this.role,
  });

  // Helper opcional para verificar de forma semántica el rol en la capa de presentación
  bool get isDriver => role == 1;
}