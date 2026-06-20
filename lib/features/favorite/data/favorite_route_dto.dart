class FavoriteRouteDto {
  final int id;
  final int passengerId;
  final int routeId;
  final String createdAt;

  FavoriteRouteDto({
    required this.id,
    required this.passengerId,
    required this.routeId,
    required this.createdAt,
  });

  factory FavoriteRouteDto.fromJson(Map<String, dynamic> json) {
    return FavoriteRouteDto(
      id: json['id'] as int? ?? 0,
      passengerId: json['passengerId'] as int? ?? 0,
      routeId: json['routeId'] as int? ?? 0,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}
