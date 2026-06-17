import '../data/create_reservation_request.dart';
import '../data/reservation_dto.dart';

abstract class ReservationRepository {
  Future<void> createReservation(CreateReservationRequest request);

  Future<List<ReservationDto>> getUserReservations(int userId);
}