import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:waypass_app/core/di/dependency_injection.dart';
import 'package:waypass_app/features/auth/data/token_manager.dart';
import 'package:waypass_app/features/travel/domain/travel_route.dart';
import '../data/paypal_service.dart';
import '../data/create_reservation_request.dart';
import '../domain/reservation_repository.dart';

class CreateReservationPage extends StatefulWidget {
  final TravelRoute route;

  const CreateReservationPage({super.key, required this.route});

  @override
  State<CreateReservationPage> createState() => _CreateReservationPageState();
}

class _CreateReservationPageState extends State<CreateReservationPage> {
  final PaypalService _paypalService = PaypalService();

  late final ReservationRepository _reservationRepository;
  late final TokenManager _tokenManager;

  WebViewController? _webViewController;

  bool _isLoadingPaypal = true;
  bool _isProcessing = false;
  bool _alreadyReserved = false;
  String? _orderId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _reservationRepository = getIt<ReservationRepository>();
    _tokenManager = getIt<TokenManager>();
    _checkAndInit();
  }

  Future<void> _checkAndInit() async {
    final userId = _tokenManager.getUserId() ?? 0;
    try {
      final reservations =
          await _reservationRepository.getUserReservations(userId);
      final exists = reservations.any((r) => r.routeId == widget.route.id);
      if (exists) {
        if (mounted) {
          setState(() {
            _alreadyReserved = true;
            _isLoadingPaypal = false;
          });
        }
        return;
      }
    } catch (_) {}
    _initPaypal();
  }

  Future<void> _initPaypal() async {
    setState(() {
      _isLoadingPaypal = true;
      _errorMessage = null;
    });
    try {
      final result = await _paypalService.createOrder(widget.route.price);
      _orderId = result.orderId;
      _setupWebView(result.approvalUrl);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'No se pudo conectar con PayPal:\n$e';
          _isLoadingPaypal = false;
        });
      }
    }
  }

  void _setupWebView(String approvalUrl) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoadingPaypal = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoadingPaypal = false);
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith(PaypalService.returnUrl)) {
              _onPaypalSuccess();
              return NavigationDecision.prevent;
            }
            if (request.url.startsWith(PaypalService.cancelUrl)) {
              _onPaypalCancel();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(approvalUrl));

    if (mounted) {
      setState(() {
        _webViewController = controller;
        _isLoadingPaypal = false;
      });
    }
  }

  Future<void> _onPaypalSuccess() async {
    if (_orderId == null || _isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      final transactionId = await _paypalService.captureOrder(_orderId!);

      final userId = _tokenManager.getUserId() ?? 0;

      final request = CreateReservationRequest(
        userId: userId,
        driverId: widget.route.id,
        routeId: widget.route.id,
        amount: widget.route.price,
        paypalTransactionId: transactionId,
      );

      await _reservationRepository.createReservation(request);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Reserva completada con éxito!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/main',
            (route) => false,
        arguments: 2,
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _errorMessage = 'Error procesando el pago:\n$e';
        });
      }
    }
  }

  void _onPaypalCancel() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pago cancelado.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar con PayPal'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_alreadyReserved) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, size: 56, color: Colors.orange),
              const SizedBox(height: 12),
              const Text(
                'Ya tienes una reserva para esta ruta.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
              ),
            ],
          ),
        ),
      );
    }

    // Error
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 56, color: Colors.red),
              const SizedBox(height: 12),
              Text(_errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _initPaypal,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_isProcessing) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Guardando tu reserva...'),
          ],
        ),
      );
    }

    if (_webViewController == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Conectando con PayPal...'),
          ],
        ),
      );
    }

    return Stack(
      children: [
        WebViewWidget(controller: _webViewController!),
        if (_isLoadingPaypal)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}