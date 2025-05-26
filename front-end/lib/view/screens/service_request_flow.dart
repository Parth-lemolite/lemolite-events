import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/app_controller.dart';
import '../../main.dart' hide AppController;
import '../widgets/contact_form.dart';
import '../widgets/gradient_button.dart';
import '../widgets/service_type_selector.dart';


class ServiceRequestFlow extends StatelessWidget {
  const ServiceRequestFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Request'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.lightImpact();
            controller.resetFlow();
            Get.back(); // Changed: Use Get.back() for navigation
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Container(
          color: Colors.white.withValues(alpha: 0.1),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Form(
                key: controller.contactFormKey, // Changed: Use contactFormKey
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service Request Details',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Provide additional details for your service needs.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    const ServiceTypeSelector(),
                    const SizedBox(height: 32),
                    Text(
                      'Contact Information',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),


                    ContactForm(
                      formKey: controller.contactFormKey,
                      nameController: controller.nameController,
                      emailController: controller.emailController,
                      companyController: controller.companyController,
                      phoneController: controller.phoneController,
                      messageController: controller.messageController,
                      messageLabel: 'Service Requirements',
                      messagePlaceholder:
                      'Tell us about your specific service needs...',
                    ),
                    const SizedBox(height: 32),
                    Obx(
                          () => GradientButton(
                        onPressed:
                        controller.isLoading.value
                            ? null
                            : () {
                          if (controller.contactFormKey.currentState !=
                              null &&
                              controller.contactFormKey.currentState!
                                  .validate()) {
                            controller.submitForm(context: context);
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: '',
                              barrierColor: Colors.black.withValues(
                                alpha: 0.2,
                              ),
                              pageBuilder: (
                                  context,
                                  animation1,
                                  animation2,
                                  ) {
                                return BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 5,
                                    sigmaY: 5,
                                  ),
                                  child: Center(
                                    child: AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(16),
                                      ),
                                      backgroundColor: Colors.white
                                          .withValues(alpha: 0.9),
                                      title: Text(
                                        'Thank You!!',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(
                                            0xFF0F1C35,
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.check_circle_outline,
                                            size: 48,
                                            color: Colors.green,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Our team will contact you shortly.',
                                            style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.w400,
                                              color: const Color(
                                                0xFF404B69,
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        Center(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              controller.resetFlow();
                                              Get.offAll(
                                                    () =>
                                                const MainScreen(),
                                              ); // Changed: Reset navigation stack
                                            },
                                            child: Text(
                                              'OK',
                                              style: GoogleFonts.inter(
                                                fontSize: 16,
                                                fontWeight:
                                                FontWeight.w600,
                                                color: const Color(
                                                  0xFF2EC4F3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please fill all required fields correctly',
                              backgroundColor: Colors.red.shade50,
                              colorText: Colors.red.shade900,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 10,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        isLoading: controller.isLoading.value,
                        text: 'Submit Service Request',
                        gradientColors: const [
                          Color(0xFFBFD633),
                          Color(0xFF2EC4F3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}