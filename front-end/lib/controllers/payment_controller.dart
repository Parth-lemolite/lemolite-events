import 'package:get/get.dart';

class PaymentController extends GetxController {
  final isLoading = false.obs;
  final paymentStatus = ''.obs;
  final totalPrice = 0.0.obs;

  Future<void> initiatePayment(String sessionId) async {
    try {
      isLoading.value = true;
      paymentStatus.value = 'Processing payment...';

      // Simulate payment processing with a delay
      await Future.delayed(const Duration(seconds: 2));

      // Always return success
      paymentStatus.value = 'Payment Successful!';
      Get.snackbar(
        'Success',
        'Payment completed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      paymentStatus.value = 'Payment Failed: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Payment failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startPayment({
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required double amount,
  }) async {
    try {
      isLoading.value = true;
      paymentStatus.value = 'Processing payment...';

      // Simulate payment processing with a delay
      await Future.delayed(const Duration(seconds: 2));

      // Always return success
      paymentStatus.value = 'Payment Successful!';
      Get.snackbar(
        'Success',
        'Payment completed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      paymentStatus.value = 'Payment Failed: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Payment failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setTotalPrice(double price) {
    totalPrice.value = price;
  }
}
