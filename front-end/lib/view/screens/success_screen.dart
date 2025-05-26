import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/app_controller.dart';
import '../../models/enums.dart';
import '../widgets/gradient_button.dart';
import 'main_screen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

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
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBFD633).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFBFD633).withValues(alpha: 0.1),
                          blurRadius: 50,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Color(0xFFBFD633),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Thank You!',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.selectedFlowType.value == FlowType.service
                        ? 'Your service request has been submitted successfully.'
                        : controller.engagementModel.value ==
                        EngagementModel.saas
                        ? 'Your payment has been processed successfully.'
                        : 'Your request for a service agreement has been submitted.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.engagementModel.value == EngagementModel.saas ||
                        controller.selectedFlowType.value ==
                            FlowType.service
                        ? 'Our team will contact you soon at ${controller.emailController.text}'
                        : "We'll get in touch with the agreement details at ${controller.emailController.text}",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 24,
                  //     vertical: 16,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white.withValues(alpha:0.9),
                  //     borderRadius: BorderRadius.circular(16),
                  //     border: Border.all(color: const Color(0xFF2EC4F3)),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       Text(
                  //         'Reference Number',
                  //         style: GoogleFonts.inter(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w500,
                  //           color: const Color(0xFF404B69),
                  //         ),
                  //       ),
                  //       const SizedBox(height: 4),
                  //       Text(
                  //         'LL${DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13)}',
                  //         style: GoogleFonts.montserrat(
                  //           fontSize: 24,
                  //           fontWeight: FontWeight.w600,
                  //           color: const Color(0xFF0F1C35),
                  //           letterSpacing: 1.5,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 48),
                  GradientButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      controller.resetFlow();
                      Get.offAll(
                            () => const MainScreen(),
                      ); // Changed: Reset navigation stack
                    },
                    isLoading: false,
                    text: 'Return to Home',
                    gradientColors: const [
                      Color(0xFFBFD633),
                      Color(0xFF2EC4F3),
                    ],
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