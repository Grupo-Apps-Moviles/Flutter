class CreateFavoriteRequest {
  final int passengerId;
  final int routeId;

  CreateFavoriteRequest({required this.passengerId, required this.routeId});

  Map<String, dynamic> toJson() => {
        'passengerId': passengerId,
        'routeId': routeId,
      };
}
