import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/create_reservation_request.dart';
import '../domain/reservation_repository.dart';
import 'reservation_state.dart';

class ReservationViewModel extends Cubit<ReservationState> {
  final ReservationRepository repository;

  ReservationViewModel({required this.repository})
      : super(ReservationInitial());

  Future<void> reserveRoute({
    required int userId,
    required int driverId,
    required int routeId,
    required double amount,
    required String paypalTransactionId,
  }) async {
    emit(ReservationLoading());
    try {
      final request = CreateReservationRequest(
        userId: userId,
        driverId: driverId,
        routeId: routeId,
        amount: amount,
        paypalTransactionId: paypalTransactionId,
      );
      await repository.createReservation(request);
      emit(ReservationSuccess());
    } catch (e) {
      emit(ReservationError(message: e.toString()));
    }
  }

  Future<void> loadUserReservations(int userId) async {
    emit(ReservationLoading());
    try {
      final reservations = await repository.getUserReservations(userId);
      emit(ReservationListLoaded(reservations: reservations));
    } catch (e) {
      emit(ReservationError(message: e.toString()));
    }
  }
}