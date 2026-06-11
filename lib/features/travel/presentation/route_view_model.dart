import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waypass_app/features/travel/domain/route_repository.dart';
import 'package:waypass_app/features/travel/presentation/route_state.dart';

class RouteViewModel extends Cubit<RouteState> {
  final RouteRepository repository;

  RouteViewModel({required this.repository}) : super(RouteInitial());

  Future<void> loadRoutes() async {
    emit(RouteLoading());
    try {
      final routes = await repository.getAllRoutes();
      emit(RouteLoaded(routes: routes));
    } catch (e) {
      emit(RouteError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}