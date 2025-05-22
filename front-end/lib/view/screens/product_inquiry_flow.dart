import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controller/product_inquiry_controller.dart';
import '../../models/enums.dart';
import '../widgets/gradient_button.dart';
import '../steps/engagement_model_step.dart';
import '../steps/product_selection_step.dart';
import '../steps/plan_pricing_step.dart';
import '../steps/contact_details_step.dart';
import '../widgets/step_progress_indicator.dart';

class ProductInquiryFlow extends StatelessWidget {
  const ProductInquiryFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductInquiryController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Product Inquiry'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.lightImpact();
            controller.goToPreviousStep();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Container(
          color: Colors.white.withValues(alpha: 0.1),
          child: SafeArea(
            child: Obx(() {
              final int activeStep = controller.activeStep.value;
              final bool isSaaS =
                  controller.engagementModel.value == EngagementModel.saas;
              final int totalSteps = isSaaS ? 4 : 3;
              final List<String> labels =
              isSaaS ? const ['Model', 'Products', 'Pricing', 'Details'] : const ['Model', 'Products', 'Details'];
              final int uiStep = isSaaS ? activeStep : (activeStep == 3 ? 2 : activeStep);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: StepProgressIndicator(
                      currentStep: uiStep,
                      totalSteps: totalSteps,
                      labels: labels,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(24),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: FadeTransition(opacity: animation, child: child),
                          );
                        },
                        child: _buildActiveStep(activeStep, controller),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Obx(() {
                      bool canProceed = true;
                      String buttonText = 'Continue';
                      VoidCallback? onPressed;
                      bool isPayment = false;
                      bool isAgreement = false;

                      if (activeStep == 0) {
                        canProceed = controller.engagementModel.value != null;
                      } else if (activeStep == 1) {
                        canProceed = controller.selectedProducts.isNotEmpty;
                        if (!isSaaS) {
                          buttonText = 'Submit for Service Agreement';
                          isAgreement = true;
                        }
                      } else if (activeStep == 2 && isSaaS) {
                        canProceed = controller.productUserCounts.isNotEmpty &&
                            controller.productUserCounts.values.every((count) => count > 0);
                        buttonText = 'Proceed to Payment';
                        isPayment = true;
                      } else if (activeStep == 3 || (activeStep == 2 && !isSaaS)) {
                        buttonText = 'Submit Inquiry';
                      }

                      onPressed = canProceed && !controller.isLoading.value
                          ? () => controller.submitForm(
                        isPayment: isPayment,
                        isAgreement: isAgreement,
                        context: context,
                      )
                          : null;

                      return GradientButton(
                        onPressed: onPressed,
                        isLoading: controller.isLoading.value,
                        text: buttonText,
                        gradientColors: canProceed && !controller.isLoading.value
                            ? const [Color(0xFFBFD633), Color(0xFF2EC4F3)]
                            : const [Color(0xFFB0BEC5), Color(0xFFCFD8DC)],
                      );
                    }),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveStep(int step, ProductInquiryController controller) {
    final bool isSaaS = controller.engagementModel.value == EngagementModel.saas;
    switch (step) {
      case 0:
        return EngagementModelStep(key: const ValueKey('step1'));
      case 1:
        return ProductSelectionStep(key: const ValueKey('step2'));
      case 2:
        return isSaaS ? PlanPricingStep(key: const ValueKey('step3')) : ContactDetailsStep(key: const ValueKey('step4'));
      case 3:
        return ContactDetailsStep(key: const ValueKey('step4'));
      default:
        return const SizedBox();
    }
  }
}