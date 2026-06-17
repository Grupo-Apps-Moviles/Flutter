class ReservationDto {
  final int id;
  final int userId;
  final int driverId;
  final int routeId;
  final double amount;
  final String status;
  final String paypalTransactionId;

  ReservationDto({
    required this.id,
    required this.userId,
    required this.driverId,
    required this.routeId,
    required this.amount,
    required this.status,
    required this.paypalTransactionId,
  });

  factory ReservationDto.fromJson(Map<String, dynamic> json) {
    return ReservationDto(
      id: json['id'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
      driverId: json['driverId'] as int? ?? 0,
      routeId: json['routeId'] as int? ??
          ((json['reservationRoutes'] as List?)?.isNotEmpty == true
              ? (json['reservationRoutes'][0]['routeId'] as int? ?? 0)
              : 0),
      amount: (json['amount'] as num? ?? 0).toDouble(),
      status: json['status'] as String? ?? '',
      paypalTransactionId: json['paypalTransactionId'] as String? ?? '',
    );
  }
}