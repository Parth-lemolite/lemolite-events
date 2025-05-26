import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controller/app_controller.dart';
import '../../models/enums.dart';
import '../widgets/gradient_button.dart';
import '../steps/engagement_model_step.dart';
import '../steps/product_selection_step.dart';
import '../steps/plan_pricing_step.dart';
import '../steps/contact_details_step.dart';
import '../widgets/step_progress_indicator.dart';
import 'check_out.dart';

class ProductInquiryFlow extends StatelessWidget {
  const ProductInquiryFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          child: Container(
            color: Colors.white.withValues(alpha: 0.1),
            child: SafeArea(
              child: Obx(() {
                final int activeStep = controller.activeStep.value;
                final bool isSaaS =
                    controller.engagementModel.value == EngagementModel.saas;
                final int totalSteps = isSaaS ? 4 : 2;
                final List<String> labels =
                isSaaS
                    ? const ['Model', 'Products', 'Pricing', 'Checkout']
                    : const ['Model', 'Products'];
                final int uiStep =
                isSaaS ? activeStep : (activeStep == 3 ? 2 : activeStep);

                debugPrint(
                  'ProductInquiryFlow rebuilt: activeStep=$activeStep, '
                      'uiStep=$uiStep, isSaaS=$isSaaS, '
                      'selectedProducts=${controller.selectedProducts}, '
                      'engagementModel=${controller.engagementModel.value}',
                );

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
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
                          transitionBuilder: (
                              Widget child,
                              Animation<double> animation,
                              ) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
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
                          debugPrint(
                            'Step 1 Button: canProceed=$canProceed, '
                                'selectedProducts=${controller.selectedProducts}, '
                                'length=${controller.selectedProducts.length}',
                          );
                        } else if (activeStep == 2 && isSaaS) {
                          canProceed =
                              controller.productUserCounts.isNotEmpty &&
                                  controller.productUserCounts.values.every(
                                        (count) => count > 0,
                                  );
                        } else if (activeStep == 3 && isSaaS) {
                          canProceed =
                              controller.productUserCounts.isNotEmpty &&
                                  controller.productUserCounts.values.every(
                                        (count) => count > 0,
                                  );
                          buttonText = 'Pay Now';
                          isPayment = true;
                        } else if (activeStep == 4 ||
                            (activeStep == 2 && !isSaaS)) {
                          buttonText = 'Submit Inquiry';
                        }

                        onPressed =
                        canProceed && !controller.isLoading.value
                            ? () async {
                          controller.isLoading.value = true;
                          HapticFeedback.lightImpact();
                          debugPrint(
                            'Button pressed: activeStep=$activeStep, '
                                'uiStep=$uiStep, canProceed=$canProceed, '
                                'selectedProducts=${controller.selectedProducts}, '
                                'isPayment=$isPayment, isAgreement=$isAgreement',
                          );
                          await controller.submitForm(
                            isPayment: isPayment,
                            isAgreement: isAgreement,
                            context: context,
                          );
                          if (buttonText == 'Pay Now') {
                            // Prepare form data
                            final formData = {
                              'companyName':
                              controller.companyController.text,
                              'fullName':
                              controller.nameController.text,
                              'email': controller.emailController.text,
                              'phoneNumber':
                              controller.phoneController.text,
                              'interestedIn': 'Product',
                              'engagementModel': controller
                                  .getApiEngagementModel(
                                controller.engagementModel.value,
                              ),
                              'selectedProducts':
                              controller.selectedProducts
                                  .map(
                                    (productName) => {
                                  'productName': productName,
                                  if (isSaaS)
                                    'userCountRange':
                                    controller
                                        .productUserRanges[productName] ??
                                        '1-10',
                                  if (isSaaS)
                                    'totalPrice':
                                    controller.productsList
                                        .firstWhere(
                                          (p) =>
                                      p.name ==
                                          productName,
                                    )
                                        .pricePerUser *
                                        (controller
                                            .productUserCounts[productName] ??
                                            1),
                                },
                              )
                                  .toList(),
                              if (isSaaS)
                                'totalAmount': controller.totalPrice,
                            };
                            if (kDebugMode) {
                              print('data====>$formData');
                            }

                            // Send data to API
                            final isSuccess = await controller
                                .sendUserData(formData);
                            if (!isSuccess) {
                              Get.snackbar(
                                'Error',
                                'Failed to submit data. Please try again.',
                                backgroundColor: Colors.red.shade50,
                                colorText: Colors.red.shade900,
                                margin: const EdgeInsets.all(16),
                                borderRadius: 10,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }

                            // Call submitForm to handle navigation and dialog
                          }
                          controller.isLoading.value = false;
                        }
                            : null;

                        return GradientButton(
                          onPressed: onPressed,
                          isLoading: controller.isLoading.value,
                          text: buttonText,
                          gradientColors:
                          canProceed && !controller.isLoading.value
                              ? const [Color(0xFFBFD633), Color(0xFF2EC4F3)]
                              : const [
                            Color(0xFFB0BEC5),
                            Color(0xFFCFD8DC),
                          ],
                        );
                      }),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveStep(int step, AppController controller) {
    final bool isSaaS =
        controller.engagementModel.value == EngagementModel.saas;
    switch (step) {
      case 0:
        return EngagementModelStep(key: const ValueKey('step1'));
      case 1:
        return ProductSelectionStep(key: const ValueKey('step2'));
      case 2:
        return isSaaS
            ? PlanPricingStep(key: const ValueKey('step3'))
            : ContactDetailsStep(key: const ValueKey('step4'));
      case 3:
        return isSaaS
            ? CheckoutStep(key: const ValueKey('step4'))
            : ContactDetailsStep(key: const ValueKey('step4'));
      case 4:
        return ContactDetailsStep(key: const ValueKey('step5'));
      default:
        return const SizedBox();
    }
  }
}