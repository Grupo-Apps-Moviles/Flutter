import '../data/reservation_dto.dart';

abstract class ReservationState {}

class ReservationInitial extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationSuccess extends ReservationState {}

class ReservationListLoaded extends ReservationState {
  final List<ReservationDto> reservations;
  final Map<int, String> driverNames;
  ReservationListLoaded({required this.reservations, this.driverNames = const {}});
}

class ReservationError extends ReservationState {
  final String message;
  ReservationError({required this.message});
}