import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nairobi_app/view/screens/product_inquiry_flow.dart';
import '../../controller/app_controller.dart';
import '../../controller/landing_controller.dart';
import '../../models/enums.dart';
import '../widgets/gradient_button.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LandingController());
    final appController = Get.put(AppController());

    return Stack(
      children: [
        Container(decoration: BoxDecoration(color: Colors.grey.shade200)),
        Container(color: Colors.white.withValues(alpha: 0.1)),
        SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: controller.landingFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Obx(() => GradientButton(
                      onPressed: () async {
                        if (controller.landingFormKey.currentState != null &&
                            controller.landingFormKey.currentState!
                                .validate()) {
                          if (controller.selectedOption.value == 'Service') {
                            final formData = {
                              'companyName': controller.companyController.text,
                              'fullName': controller.nameController.text,
                              'email': controller.emailController.text,
                              'phoneNumber': controller.phoneController.text,
                              'interestedIn': 'Service',
                            };
                            final isSuccess =
                            await controller.sendUserData(formData);
                            if (isSuccess) {
                              appController.isSubmitted.value = true;
                              // Show success dialog
                            }
                          } else if (controller.selectedOption.value ==
                              'Product') {
                            appController.selectFlowType(FlowType.product);
                            Get.off(() => const ProductInquiryFlow());
                          } else {
                            Get.snackbar(
                              'Selection Required',
                              'Please select Service or Product',
                              backgroundColor: Colors.red.shade50,
                              colorText: Colors.red.shade900,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 10,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        }
                      },
                      isLoading: controller.isLoading.value,
                      text: controller.selectedOption.value == 'Service'
                          ? 'Submit Request'
                          : 'Next',
                      gradientColors: const [
                        Color(0xFFBFD633),
                        Color(0xFF2EC4F3),
                      ],
                    )),
                    // ... Policy buttons as in original
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}