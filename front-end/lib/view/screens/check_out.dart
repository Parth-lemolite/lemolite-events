import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nairobi_app/controllers/payment_controller.dart';


class CheckoutStep extends StatelessWidget {
  const CheckoutStep({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController paymentController = Get.put(PaymentController());
    const String sessionId =
        'session_AX_S1E1-LcXbmOZzE6qEYR_88EMyaqWhkLHNSlAV-Kf_1IDuub4-SYllmjQYvnLE7TB06bxY-CDQ6qDClqqVkMjXlY3_Ry_YH9e2JCHJS1xWLrPAFnm-5n32RXXdgQpaymentpayment';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Checkout', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Complete your payment securely.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Summary',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F1C35),
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF404B69),
                      ),
                    ),
                    Obx(() {
                      return Text(
                        '₹${paymentController.totalPrice.value.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2EC4F3),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: Obx(() {
                    return ElevatedButton(
                      onPressed:
                          paymentController.isLoading.value
                              ? null
                              : () =>
                                  paymentController.initiatePayment(sessionId),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        backgroundColor: const Color(0xFF2EC4F3),
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
                                : 'Pay Securely',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                if (paymentController.paymentStatus.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Center(
                      child: Text(
                        paymentController.paymentStatus.value,
                        style: TextStyle(
                          color:
                              paymentController.paymentStatus.value.contains(
                                    'Success',
                                  )
                                  ? Colors.green
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2EC4F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    color: Color(0xFF2EC4F3),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Your payment is secured by Cashfree Payment Gateway',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF404B69),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CardItem extends StatelessWidget {
  final String cardNumber;
  final String expiryDate;
  final String cardHolder;
  final VoidCallback onRemove;

  const CardItem({
    super.key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolder,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF2EC4F3).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.credit_card,
                color: Color(0xFF2EC4F3),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardNumber,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF0F1C35),
                    ),
                  ),
                  Text(
                    'Expires: $expiryDate',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF404B69),
                    ),
                  ),
                  Text(
                    cardHolder,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF404B69),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(' ', '');
    if (newText.length > 16) {
      newText = newText.substring(0, 16);
    }
    String formatted = '';
    for (int i = 0; i < newText.length; i++) {
      formatted += newText[i];
      if ((i + 1) % 4 == 0 && i + 1 < newText.length) {
        formatted += ' ';
      }
    }
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll('/', '');
    if (newText.length > 4) {
      newText = newText.substring(0, 4);
    }
    String formatted = '';
    if (newText.length > 2) {
      formatted = '${newText.substring(0, 2)}/${newText.substring(2)}';
    } else {
      formatted = newText;
    }
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
