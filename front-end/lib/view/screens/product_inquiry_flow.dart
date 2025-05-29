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

class ProductInquiryFlow extends StatelessWidget {
  const ProductInquiryFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    return Scaffold(
      backgroundColor: Colors.white,
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
                final int totalSteps = isSaaS ? 3 : 2;
                final List<String> labels = isSaaS
                    ? const ['Model', 'Products', 'Pricing']
                    : const ['Model', 'Products'];
                final int uiStep = activeStep;

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
                        } else if (activeStep == 2 && isSaaS) {
                          // For the pricing step (step 2 for SaaS), button is always enabled
                          canProceed =
                              true; // Button is always enabled for this step
                          buttonText = 'Submit';
                          isPayment = true;
                        }

                        onPressed = canProceed && !controller.isLoading.value
                            ? () async {
                                controller.isLoading.value = true;
                                HapticFeedback.lightImpact();

                                if (isPayment) {
                                  // Prepare form data for payment
                                  final formData = {
                                    'companyName':
                                        controller.companyController.text,
                                    'fullName': controller.nameController.text,
                                    'email': controller.emailController.text,
                                    'phoneNumber':
                                        controller.phoneController.text,
                                    'interestedIn': 'Product',
                                    'engagementModel':
                                        controller.getApiEngagementModel(
                                      controller.engagementModel.value,
                                    ),
                                    'selectedProducts': controller
                                        .selectedProducts
                                        .map((productName) {
                                      final selectedPlan = controller
                                              .productPlans[productName] ??
                                          'Free';
                                      final userCount = selectedPlan ==
                                                  'Free' ||
                                              selectedPlan.contains('One Time')
                                          ? 1
                                          : controller.productUserCounts[
                                                  productName] ??
                                              1;
                                      final plansAndPrices =
                                          getProductPlansAndPrices(
                                              productName); // Use local method
                                      final pricePerUser =
                                          plansAndPrices['prices'][selectedPlan]
                                              as double;
                                      final totalPrice =
                                          selectedPlan.contains('One Time')
                                              ? pricePerUser
                                              : pricePerUser * userCount;

                                      return {
                                        'productName': productName,
                                        'planName': selectedPlan,
                                        'userCountRange': userCount.toString(),
                                        'totalPrice': totalPrice,
                                      };
                                    }).toList(),
                                    'totalAmount': controller.totalPrice.value,
                                  };
                                  // Check form validity before proceeding with payment submission
                                  if (controller.pricingFormKey.currentState!
                                      .validate()) {
                                    // Show custom confirmation dialog
                                    final bool? confirmed =
                                        await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Confirm Submission'),
                                          content: const Text(
                                              'Do you want to confirm and submit the pricing details?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop(
                                                    false); // Return false on Cancel
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Confirm'),
                                              onPressed: () {
                                                Navigator.of(context).pop(
                                                    true); // Return true on Confirm
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    // Only proceed if user confirmed
                                    if (confirmed == true) {
                                      await controller.sendUserData(formData);
                                    } else {
                                      debugPrint(
                                          'Submission cancelled by user via custom dialog.');
                                    }
                                  } else {
                                    // If validation fails, do not proceed with API call
                                    debugPrint(
                                        'Pricing form validation failed on submit.');
                                    // TODO: Implement scrolling to the first invalid field
                                    Get.snackbar(
                                      'Validation Error',
                                      'Please fix the user count ranges.',
                                      backgroundColor: Colors.red.shade50,
                                      colorText: Colors.red.shade900,
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 10,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  }
                                }
                                else if (isAgreement) {
                                  // Handle service agreement submission
                                  // await controller.submitForm(
                                  //   isAgreement: true,
                                  //   context: context,
                                  // );

                                  final bool? confirmed =
                                  await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirm Submission'),
                                        content: const Text(
                                            'Do you want to confirm and submit the pricing details?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop(
                                                  false); // Return false on Cancel
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Confirm'),
                                            onPressed: () {
                                              Navigator.of(context).pop(
                                                  true); // Return true on Confirm
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );


                                } else {
                                  // Handle normal flow
                                  controller.goToNextStep(context);
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
        return const EngagementModelStep(key: ValueKey('step1'));
      case 1:
        return const ProductSelectionStep(key: ValueKey('step2'));
      case 2:
        return isSaaS
            ? const PlanPricingStep(key: ValueKey('step3'))
            : const ContactDetailsStep(key: ValueKey('step4'));
      default:
        return const SizedBox();
    }
  }

  // Duplicate getProductPlansAndPrices to avoid dependency on PlanPricingStep
  Map<String, dynamic> getProductPlansAndPrices(String productName) {
    productName = productName.toLowerCase().trim();

    if (productName.contains('integrated') ||
        productName.contains('s2h + nexstaff')) {
      return {
        'plans': ['SaaS Based', 'One Time Cost'],
        'prices': {
          'SaaS Based': 89.0,
          'One Time Cost': 56500.0,
        },
      };
    }

    if (productName.contains('scan2hire') || productName.contains('s2h')) {
      return {
        'plans': ['Free', 'Premium', 'Enterprise'],
        'prices': {
          'Free': 0.0,
          'Premium': 49.0,
          'Enterprise': 79.0,
        },
      };
    }

    if (productName.contains('nexstaff')) {
      return {
        'plans': ['Free', 'Growth', 'Premium'],
        'prices': {
          'Free': 0.0,
          'Growth': 39.0,
          'Premium': 69.0,
        },
      };
    }

    if (productName == 'crm') {
      return {
        'plans': ['Growth', 'Enterprise'],
        'prices': {
          'Growth': 19.0,
          'Enterprise': 29.0,
        },
      };
    }

    if (productName == 'ims') {
      return {
        'plans': ['Enterprise'],
        'prices': {
          'Enterprise': 19.0,
        },
      };
    }

    return {
      'plans': ['Free'],
      'prices': {'Free': 0.0},
    };
  }
}
