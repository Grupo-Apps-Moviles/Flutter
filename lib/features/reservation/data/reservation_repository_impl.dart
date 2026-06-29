import '../data/create_reservation_request.dart';
import '../data/reservation_dto.dart';
import '../data/reservation_service.dart';
import '../domain/reservation_repository.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final ReservationService service;

  ReservationRepositoryImpl({required this.service});

  @override
  Future<void> createReservation(CreateReservationRequest request) {
    return service.createReservation(request);
  }

  @override
  Future<List<ReservationDto>> getUserReservations(int userId) {
    return service.getUserReservations(userId);
  }

  @override
  Future<String> getDriverName(int driverId) {
    return service.getUsernameById(driverId);
  }
}