import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../service/payment_service.dart';
import '../widgets/gradient_button.dart';
import 'main_screen.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String? orderId;

  const PaymentSuccessScreen({Key? key, this.orderId}) : super(key: key);

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  bool isLoading = true;
  bool isSuccess = false;
  String message = 'Checking payment status...';

  @override
  void initState() {
    super.initState();
    check();
  }

  int retryCount = 0;
  final int maxRetries = 12;

  void check() async {
    while (mounted && retryCount < maxRetries) {
      await _checkPaymentStatus();
      if (isSuccess) break;
      retryCount++;
      await Future.delayed(const Duration(seconds: 5));
    }

    if (!isSuccess && mounted) {
      setState(() {
        message = 'Unable to verify payment after multiple attempts.';
      });
    }
  }


  Future<void> _checkPaymentStatus() async {
    if (widget.orderId == null || widget.orderId!.isEmpty) {
      setState(() {
        isSuccess = false;
        message = 'Error: No Order ID provided.';
        isLoading = false;
      });
      return;
    }

    try {
      final response = await PaymentService.verifyPayment(widget.orderId!);

      final paymentStatus = response["data"]?["payment"]?["status"]?.toLowerCase() ?? '';


      print("DEBUG: paymentStatus = $paymentStatus,");

      if (paymentStatus == "completed" ) {
        setState(() {
          isSuccess = true;
          message = 'Payment Successful!';
          isLoading = false;
        });
      } else {
        setState(() {
          isSuccess = false;
          message = 'Payment status: $paymentStatus ';
        });
      }
    } catch (e) {
      setState(() {
        isSuccess = false;
        message = 'Error verifying payment. Retrying...';
        print("Error verifying payment: $e");
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSuccess ? Icons.check_circle_outline : Icons.cancel_outlined,
                  size: 72,
                  color: isSuccess ? Colors.green.shade600 : Colors.red.shade600,
                ),
                const SizedBox(height: 32),
                Text(
                  message,
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F1C35),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Order ID: ${widget.orderId}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF404B69),
                  ),
                ),
                const SizedBox(height: 32),
                if (isSuccess) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.green.shade50,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "What's Next?",
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F1C35),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Our team will contact you shortly with the next steps.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF404B69),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                GradientButton(
                  onPressed: () => Get.offAll(() => const MainScreen()),
                  text: 'Back to Home',
                  gradientColors: isSuccess
                      ? const [Color(0xFFBFD633), Color(0xFF2EC4F3)]
                      : const [Colors.redAccent, Colors.orange],
                  isLoading: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}