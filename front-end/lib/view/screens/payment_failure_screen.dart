import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/gradient_button.dart';
import 'main_screen.dart';

class PaymentFailureScreen extends StatelessWidget {
  final String orderId;
  final String message;

  const PaymentFailureScreen({
    Key? key,
    required this.orderId,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade50,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 72,
                  color: Colors.red.shade600,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Payment Failed',
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F1C35),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF404B69),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Order ID: $orderId',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF404B69),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.red.shade50,
                ),
                child: Column(
                  children: [
                    Text(
                      'What Should I Do?',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F1C35),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Please try again or contact our support team if the problem persists. We\'re here to help!',
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
              GradientButton(
                onPressed: () => Get.offAll(() => const MainScreen()),
                text: 'Back to Home',
                gradientColors: const [Color(0xFFBFD633), Color(0xFF2EC4F3)],
                isLoading: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
