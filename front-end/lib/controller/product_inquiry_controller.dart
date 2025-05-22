import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_info.dart';
import '../models/enums.dart';
import '../view/screens/main_screen.dart';
import 'app_controller.dart';

class ProductInquiryController extends GetxController {
  final Rx<EngagementModel?> engagementModel = Rx<EngagementModel?>(null);
  final RxMap<String, String> productUserRanges = <String, String>{}.obs;
  final RxList<String> selectedProducts = <String>[].obs;
  final RxMap<String, int> productUserCounts = <String, int>{}.obs;
  final RxInt activeStep = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();
  final pricingFormKey = GlobalKey<FormState>();
  final contactFormKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> userCountControllers = {};

  List<ProductInfo> get productsList => [
    ProductInfo(
      name: 'Scan2Hire (S2H)',
      description: 'Advanced document scanning & AI processing for hiring',
      icon: Icons.document_scanner_outlined,
      color: const Color(0xFF2EC4F3),
      pricePerUser: 500.0,
    ),
    // ... other products as in original code
  ];

  double get totalPrice {
    double total = 0.0;
    for (var productName in selectedProducts) {
      final product = productsList.firstWhere((p) => p.name == productName);
      final userCount = productUserCounts[productName] ?? 1;
      total += product.pricePerUser * userCount;
    }
    return total;
  }

  String getApiEngagementModel(EngagementModel? model) {
    switch (model) {
      case EngagementModel.saas:
        return 'SaaS-Based Subscription';
      case EngagementModel.reseller:
        return 'Reseller';
      case EngagementModel.partner:
        return 'Partner';
      case EngagementModel.whitelabel:
        return 'Whitelabel';
      default:
        return '';
    }
  }

  @override
  void onInit() {
    super.onInit();
    for (var product in productsList) {
      userCountControllers[product.name] = TextEditingController(text: '1');
      productUserRanges[product.name] = '1-10';
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    companyController.dispose();
    phoneController.dispose();
    messageController.dispose();
    userCountControllers.forEach((_, controller) => controller.dispose());
    super.onClose();
  }

  void selectEngagementModel(EngagementModel model) {
    engagementModel.value = model;
    debugPrint('Selected engagement model: $model');
  }

  void updateUserRange(String productName, String range) {
    productUserRanges[productName] = range;
    final minUsers = int.parse(range.split('-')[0]);
    productUserCounts[productName] = minUsers;
    userCountControllers[productName]!.text = minUsers.toString();
    debugPrint('Updated user range for $productName: $range, users: $minUsers');
  }

  void toggleProduct(String productName) {
    if (selectedProducts.contains(productName)) {
      selectedProducts.remove(productName);
      productUserCounts.remove(productName);
      userCountControllers[productName]!.text = '1';
    } else {
      selectedProducts.add(productName);
      productUserCounts[productName] =
          int.tryParse(userCountControllers[productName]!.text) ?? 1;
    }
    selectedProducts.refresh();
    debugPrint('Toggled product: $productName');
  }

  void updateUserCount(String productName, String value) {
    final count = int.tryParse(value) ?? 1;
    if (count > 0) {
      productUserCounts[productName] = count;
    } else {
      productUserCounts.remove(productName);
      selectedProducts.remove(productName);
      userCountControllers[productName]!.text = '1';
    }
  }

  void goToNextStep() {
    if (activeStep.value < totalSteps - 1) {
      if (activeStep.value == 1 && engagementModel.value != EngagementModel.saas) {
        activeStep.value = 3;
      } else {
        activeStep.value++;
      }
    }
  }

  void goToPreviousStep() {
    if (activeStep.value > 0) {
      if (activeStep.value == 3 && engagementModel.value != EngagementModel.saas) {
        activeStep.value = 1;
      } else {
        activeStep.value--;
      }
    } else {
      Get.find<AppController>().resetFlow();
      Get.off(() => const MainScreen());
    }
  }

  int get totalSteps => engagementModel.value == EngagementModel.saas ? 4 : 3;

  Future<void> processPayment() async {
    // Payment processing logic as in original code
  }

  Future<void> sendEmails({bool isPayment = false, bool isAgreement = false}) async {
    // Email sending logic as in original code
  }

  Future<void> submitForm({
    required BuildContext context,
    bool isPayment = false,
    bool isAgreement = false,
  }) async {
    // Form submission logic as in original code
  }
}