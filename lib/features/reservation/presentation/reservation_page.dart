import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waypass_app/core/di/dependency_injection.dart';
import 'package:waypass_app/features/auth/data/token_manager.dart';
import '../data/reservation_dto.dart';
import 'reservation_view_model.dart';
import 'reservation_state.dart';

class ReservationPage extends StatelessWidget {
  const ReservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final vm = getIt<ReservationViewModel>();
        final userId = getIt<TokenManager>().getUserId() ?? 0;
        vm.loadUserReservations(userId);
        return vm;
      },
      child: const _ReservationView(),
    );
  }
}

class _ReservationView extends StatelessWidget {
  const _ReservationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<ReservationViewModel, ReservationState>(
        builder: (context, state) {
          if (state is ReservationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReservationError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 48,
                        color: Theme.of(context).colorScheme.error),
                    const SizedBox(height: 12),
                    Text(state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error)),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        final userId =
                            getIt<TokenManager>().getUserId() ?? 0;
                        context
                            .read<ReservationViewModel>()
                            .loadUserReservations(userId);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ReservationListLoaded) {
            if (state.reservations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_outlined,
                        size: 64,
                        color:
                        Theme.of(context).colorScheme.outlineVariant),
                    const SizedBox(height: 16),
                    Text(
                      'No tienes reservas aún.',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () {
                final userId = getIt<TokenManager>().getUserId() ?? 0;
                return context
                    .read<ReservationViewModel>()
                    .loadUserReservations(userId);
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.reservations.length,
                itemBuilder: (context, index) =>
                    _ReservationCard(dto: state.reservations[index]),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final ReservationDto dto;

  const _ReservationCard({required this.dto});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(dto.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reserva #${dto.id}',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Chip(
                  label: Text(_statusLabel(dto.status),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  backgroundColor: statusColor,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _infoRow(Icons.directions_bus,
                'Ruta ID: ${dto.routeId}', theme),
            const SizedBox(height: 6),
            _infoRow(Icons.person_outline,
                'Conductor ID: ${dto.driverId}', theme),
            const SizedBox(height: 6),
            _infoRow(Icons.attach_money,
                'Monto: S/ ${dto.amount.toStringAsFixed(2)}', theme),
            const SizedBox(height: 6),
            _infoRow(Icons.receipt_outlined,
                'PayPal TX: ${dto.paypalTransactionId}', theme,
                small: true),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, ThemeData theme,
      {bool small = false}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: small
                  ? theme.textTheme.bodySmall
                  ?.copyWith(color: Colors.grey[600])
                  : theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Pagado';
      case 'pendingpayment':
      case 'pending':
        return 'Pendiente';
      case 'canceled':
        return 'Cancelado';
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}