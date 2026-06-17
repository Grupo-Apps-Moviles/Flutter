class CreateReservationRequest {
  final int userId;
  final int driverId;
  final List<int> routeIds;
  final double amount;
  final String paypalTransactionId;

  CreateReservationRequest({
    required this.userId,
    required this.driverId,
    required int routeId,
    required this.amount,
    required this.paypalTransactionId,
  }) : routeIds = [routeId];

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'driverId': driverId,
      'routeIds': routeIds,
      'amount': amount,
      'paypalTransactionId': paypalTransactionId,
    };
  }
}