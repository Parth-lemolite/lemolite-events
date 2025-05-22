import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/app_controller.dart';
import '../../models/enums.dart';
import 'landing_screen.dart';
import 'service_request_flow.dart';
import 'product_inquiry_flow.dart';
import 'success_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.put(AppController());
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Obx(
              () => controller.isSubmitted.value
              ? const SuccessScreen()
              : controller.selectedFlowType.value == null
              ? const LandingScreen()
              : controller.selectedFlowType.value == FlowType.service
              ? const ServiceRequestFlow()
              : const ProductInquiryFlow(),
        ),
      ),
    );
  }
}