import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_controller.dart';

class PaymentButton extends StatelessWidget {
  final String sessionId;
  final String buttonText;
  final double amount;

  const PaymentButton({
    Key? key,
    required this.sessionId,
    required this.amount,
    this.buttonText = 'Pay Now',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PaymentController paymentController = Get.put(PaymentController());

    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed:
                paymentController.isLoading.value
                    ? null
                    : () => paymentController.initiatePayment(sessionId),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (paymentController.isLoading.value)
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                Text(
                  paymentController.isLoading.value
                      ? 'Processing...'
                      : '$buttonText (₹${amount.toStringAsFixed(2)})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (paymentController.paymentStatus.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                paymentController.paymentStatus.value,
                style: TextStyle(
                  color:
                      paymentController.paymentStatus.value.contains('Success')
                          ? Colors.green
                          : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      );
    });
  }
}
