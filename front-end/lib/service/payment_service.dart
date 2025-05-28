import 'package:dio/dio.dart';

class PaymentService {
  static final Dio _dio = Dio();
  static const String baseUrl = 'https://events.lemolite360.in';

  static Future<Map<String, dynamic>> verifyPayment(String orderId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/leads/payment/callback',
        queryParameters: {'order_id': orderId},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to verify payment');
      }
    } catch (e) {
      throw Exception('Error verifying payment: $e');
    }
  }
}
