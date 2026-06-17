import 'dart:convert';
import 'package:http/http.dart' as http;

class PaypalService {
  static const String _clientId = 'AVrGjFqlbali0jMFL4d72QECzvnUdYQZZ72w64KAC9Iijsad--J-iT7fol2njscH2NiNcL8Snfeo4TnP';
  static const String _secret = 'ELGQIA6WCym5JuWS_1u6k4ZSvXyYLTDMKZjXnL5nh69c64q6FbR8sOrIbDSRvttpJboOY-GrZJ0xP3Fq';
  static const String _baseUrl = 'https://api-m.sandbox.paypal.com';

  static const String returnUrl = 'waypass://paypal/success';
  static const String cancelUrl = 'waypass://paypal/cancel';

  Future<String> _getAccessToken() async {
    final credentials =
    base64Encode(utf8.encode('$_clientId:$_secret'));

    final response = await http.post(
      Uri.parse('$_baseUrl/v1/oauth2/token'),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode != 200) {
      throw Exception('Error obteniendo token PayPal');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['access_token'] as String;
  }

  Future<({String approvalUrl, String orderId})> createOrder(
      double amount) async {
    final token = await _getAccessToken();

    final body = {
      'intent': 'CAPTURE',
      'purchase_units': [
        {
          'amount': {
            'currency_code': 'USD',
            'value': amount.toStringAsFixed(2),
          },
          'description': 'Reserva de viaje - WayPass',
        }
      ],
      'application_context': {
        'brand_name': 'WayPass',
        'locale': 'es-PE',
        'shipping_preference': 'NO_SHIPPING',
        'user_action': 'PAY_NOW',
        'return_url': returnUrl,
        'cancel_url': cancelUrl,
      },
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/v2/checkout/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 201) {
      throw Exception('Error creando orden PayPal: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final orderId = data['id'] as String;

    final links = data['links'] as List<dynamic>;
    final approvalUrl = links
        .firstWhere(
          (l) => (l as Map<String, dynamic>)['rel'] == 'approve',
    )['href'] as String;

    return (approvalUrl: approvalUrl, orderId: orderId);
  }

  Future<String> captureOrder(String orderId) async {
    final token = await _getAccessToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/v2/checkout/orders/$orderId/capture'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error capturando pago PayPal: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final captureId = (((data['purchase_units'] as List).first
    as Map<String, dynamic>)['payments']
    as Map<String, dynamic>)['captures'][0]['id'] as String;

    return captureId;
  }
}