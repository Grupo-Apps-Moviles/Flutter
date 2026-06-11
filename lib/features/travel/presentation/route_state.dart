import 'package:waypass_app/features/travel/domain/travel_route.dart';

sealed class RouteState {}

class RouteInitial extends RouteState {}

class RouteLoading extends RouteState {}

class RouteLoaded extends RouteState {
  final List<TravelRoute> routes;
  RouteLoaded({required this.routes});
}

class RouteError extends RouteState {
  final String message;
  RouteError({required this.message});
}