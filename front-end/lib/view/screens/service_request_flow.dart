import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/app_controller.dart';
import '../../controller/service_request_controller.dart';
import '../widgets/gradient_button.dart';


class ServiceRequestFlow extends StatelessWidget {
  const ServiceRequestFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceRequestController>();
    final appController = Get.find<AppController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Request'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.lightImpact();
            appController.resetFlow();
            Get.back();
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
                key: controller.contactFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ... UI as in original ServiceRequestFlow
                    Obx(() => GradientButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.submitForm(context),
                      isLoading: controller.isLoading.value,
                      text: 'Submit Service Request',
                      gradientColors: const [
                        Color(0xFFBFD633),
                        Color(0xFF2EC4F3),
                      ],
                    )),
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