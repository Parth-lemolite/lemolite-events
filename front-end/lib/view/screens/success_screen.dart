import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/app_controller.dart';
import '../../controller/product_inquiry_controller.dart';
import '../widgets/gradient_button.dart';
import 'main_screen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final productController = Get.find<ProductInquiryController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Container(
          color: Colors.white.withValues(alpha: 0.1),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ... UI as in original SuccessScreen
                  GradientButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      appController.resetFlow();
                      Get.offAll(() => const MainScreen());
                    },
                    isLoading: false,
                    text: 'Return to Home',
                    gradientColors: const [Color(0xFFBFD633), Color(0xFF2EC4F3)],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}