import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/enums.dart';
import '../models/get_payment_user_data.dart';
import '../models/product_info.dart';
import '../service/api_service.dart';
import '../view/screens/main_screen.dart';
import '../view/screens/payment_success_screen.dart';
import '../service/payment_service.dart';
import '../view/screens/payment_failure_screen.dart';

class AppController extends GetxController {
  final RxMap<String, String> productPlans = <String, String>{}.obs;
  final RxDouble totalPrice = 0.0.obs;
  final Rx<FlowType?> selectedFlowType = Rx<FlowType?>(null);
  final Rx<EngagementModel?> engagementModel = Rx<EngagementModel?>(null);
  final RxMap<String, String> productUserRanges = <String, String>{}.obs;
  final RxList<String> selectedProducts = <String>[].obs;
  final RxMap<String, int> productUserCounts = <String, int>{}.obs;
  final RxBool isSubmitted = false.obs;
  final RxBool hasError = false.obs;
  final RxInt activeStep = 0.obs;
  final RxBool isLoading = false.obs;
  final RxList<Map<String, String>> savedCards = <Map<String, String>>[].obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();

  final productFormKey = GlobalKey<FormState>();
  final landingFormKey = GlobalKey<FormState>();
  final serviceFormKey = GlobalKey<FormState>();
  final pricingFormKey = GlobalKey<FormState>();
  final contactFormKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> userCountControllers = {};

  // Helper method to get plans and prices (duplicated from PlanPricingStep for price calculation)
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
        'plans': ['Freemium', 'Premium', 'Enterprise'],
        'prices': {
          'Freemium': 0.0,
          'Premium': 49.0,
          'Enterprise': 79.0,
        },
      };
    }

    if (productName.contains('nexstaff')) {
      return {
        'plans': ['Freemium', 'Enterprise'],
        'prices': {
          'Freemium': 0.0,
          'Enterprise': 69.0,
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
      'plans': ['Freemium'],
      'prices': {'Freemium': 0.0},
    };
  }

  void updatePlan(String productName, String plan) {
    productPlans[productName] = plan;
    int minUsers = plan == 'Freemium'
        ? 1
        : (plan == 'Premium'
            ? 1
            : 1); // Adjusted for Freemium/Premium/Enterprise
    productUserCounts[productName] = minUsers;
    userCountControllers[productName]!.text = minUsers.toString();
    debugPrint('Updated plan for $productName: $plan, users: $minUsers');
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

  List<ProductInfo> get productsList => [
        ProductInfo(
          name: 'Scan2Hire (S2H)',
          description: 'Advanced document scanning & AI processing for hiring',
          icon: Icons.document_scanner_outlined,
          color: const Color(0xFF2EC4F3),
          pricePerUser:
              500.0, // Note: This is overridden by getProductPlansAndPrices
        ),
        ProductInfo(
          name: 'Nexstaff',
          description: 'Comprehensive workforce management platform',
          icon: Icons.people_outline,
          color: const Color(0xFFBFD633),
          pricePerUser: 300.0,
        ),
        ProductInfo(
          name: 'Integrated (S2H + Nexstaff)',
          description: 'Seamless staffing and document solution',
          icon: Icons.integration_instructions_outlined,
          color: const Color(0xFF2EC4B6),
          pricePerUser: 700.0,
        ),
        ProductInfo(
          name: 'CRM',
          description: 'Customer relationship management ecosystem',
          icon: Icons.handshake_outlined,
          color: const Color(0xFFBFD633),
          pricePerUser: 400.0,
        ),
        ProductInfo(
          name: 'IMS',
          description: 'Precision inventory management system',
          icon: Icons.inventory_2_outlined,
          color: const Color(0xFF2EC4F3),
          pricePerUser: 350.0,
        ),
        ProductInfo(
          name: 'Dukadin',
          description: 'Enterprise resource planning solution',
          icon: Icons.business_outlined,
          color: const Color(0xFF2EC4B6),
          pricePerUser: 600.0,
        ),
      ];

  void updateUserRange(String productName, String range) {
    productUserRanges[productName] = range;
    final minUsers = int.parse(range.split('-')[0]);
    productUserCounts[productName] = minUsers;
    userCountControllers[productName]!.text = minUsers.toString();
    totalPrice; // Update total
    debugPrint('Updated user range for $productName: $range, users: $minUsers');
  }

  void addCard(Map<String, String> card) {
    savedCards.add(card);
    debugPrint('Added card: ${card['cardNumber']}');
  }

  void removeCard(int index) {
    savedCards.removeAt(index);
    debugPrint('Removed card at index: $index');
  }

  int get totalSteps => engagementModel.value == EngagementModel.saas ? 5 : 3;

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

  void resetFlow() {
    try {
      nameController.clear();
      emailController.clear();
      companyController.clear();
      phoneController.clear();
      messageController.clear();

      selectedFlowType.value = null;
      engagementModel.value = null;
      selectedProducts.clear();
      productUserCounts.clear();
      productUserRanges.clear();
      savedCards.clear();
      productPlans.clear();
      totalPrice.value = 0.0;
      isSubmitted.value = false;
      hasError.value = false;
      activeStep.value = 0;
      isLoading.value = false;

      for (var controller in userCountControllers.values) {
        controller.text = '1';
      }

      for (var product in productsList) {
        productUserRanges[product.name] = '1-10';
      }

      debugPrint('Flow reset completed');
    } catch (e) {
      debugPrint('Error during flow reset: $e');
    }
  }

  Future<bool> sendUserData(Map<String, dynamic> data2) async {
    Map<String, dynamic> convertRxDoubleToDouble(Map<String, dynamic> data) {
      final converted = <String, dynamic>{};
      data.forEach((key, value) {
        if (value is RxDouble) {
          converted[key] = value.value;
        } else if (value is List) {
          converted[key] = value.map((item) {
            if (item is Map<String, dynamic>) {
              return convertRxDoubleToDouble(item);
            }
            return item;
          }).toList();
        } else if (value is Map<String, dynamic>) {
          converted[key] = convertRxDoubleToDouble(value);
        } else {
          converted[key] = value;
        }
      });
      return converted;
    }

    double calculateTotalAmount(Map<String, dynamic> data) {
      final selectedProducts = data['selectedProducts'] as List<dynamic>? ?? [];
      return selectedProducts.fold(0.0, (sum, product) {
        final totalPrice = product['totalPrice'];
        return sum +
            (totalPrice is RxDouble ? totalPrice.value : totalPrice as double);
      });
    }

    try {
      EasyLoading.show(status: "Loading...");

      final convertedData = convertRxDoubleToDouble(data2);
      convertedData['totalAmount'] = calculateTotalAmount(convertedData);

      if (kDebugMode) {
        print('body====>$convertedData');
      }

      final response = await ApiService.post(
        convertedData,
        'https://events.lemolite360.in/api/leads',
      );


      if (response != null && response.statusCode == 201) {
        final responseData =
            GetPaymentData.fromJson(response.data as Map<String, dynamic>);
        if (kDebugMode) {
          print('Parsed Response: $responseData');
        }

        // final String? orderId = responseData.data?.payment?.orderId;
        // final String? paymentSessionId = responseData.paymentSessionId;
        //
        // if (orderId != null && paymentSessionId != null) {
        //   if (kDebugMode) {
        //     print("Order ID: $orderId");
        //     print("Payment Session ID: $paymentSessionId");
        //   }
        //   await webCheckout(
        //       orderId: orderId, paymentSessionId: paymentSessionId);
        // } else {
        //   if (kDebugMode) {
        //     print(
        //         'Error: orderId or paymentSessionId is missing in the response');
        //   }
        // }
        showSuccessDialog(Get.context!);
        EasyLoading.dismiss();
        return true;
      } else {
        if (kDebugMode) {
          print('Error: ${response?.statusCode} - ${response?.data}');
        }
        EasyLoading.dismiss();
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending user data: $e');
      }
      EasyLoading.dismiss();
      return false;
    }
  }

  void onPaymentVerify(String orderId) async {
    if (kDebugMode) {
      print("Payment verification started for order: $orderId");
    }

    try {
      final response = await PaymentService.verifyPayment(orderId);

      if (kDebugMode) {
        print("Payment verification response: $response");
      }

      final bool success = response['success'] ?? false;
      final String message = response['message'] ?? 'Unknown status';
      final paymentStatus =
          response['data']?['payment']?['status']?.toString().toLowerCase() ??
              'unknown';

      EasyLoading.dismiss();

      final currentProducts = [...selectedProducts];
      final currentEngagementModel = engagementModel.value;
      final currentPlans = Map<String, String>.from(productPlans);
      final currentUserCounts = Map<String, int>.from(productUserCounts);

      selectedProducts.clear();
      engagementModel.value = null;
      productPlans.clear();
      productUserCounts.clear();
      activeStep.value = 0;

      if (success && paymentStatus == 'completed') {
        await Get.offAll(
          () => PaymentSuccessScreen(orderId: orderId),
          predicate: (route) => false,
        );

        Get.snackbar(
          'Success',
          'Payment successful!',
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade900,
          margin: const EdgeInsets.all(16),
          borderRadius: 10,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        await Get.offAll(
          () => PaymentFailureScreen(
            orderId: orderId,
            message: message,
          ),
          predicate: (route) => false,
        );

        Get.snackbar(
          'Failed',
          message,
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          margin: const EdgeInsets.all(16),
          borderRadius: 10,
          snackPosition: SnackPosition.BOTTOM,
        );

        selectedProducts.addAll(currentProducts);
        engagementModel.value = currentEngagementModel;
        productPlans.addAll(currentPlans);
        productUserCounts.addAll(currentUserCounts);
      }

      Future.delayed(const Duration(milliseconds: 300), () {
        if (success && paymentStatus == 'completed') {
          resetFlow();
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print("Payment verification error: $e");
      }

      await Get.offAll(
        () => PaymentFailureScreen(
          orderId: orderId,
          message:
              'An error occurred while verifying the payment. Please contact support.',
        ),
        predicate: (route) => false,
      );

      Get.snackbar(
        'Error',
        'Failed to verify payment status',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onPaymentError(CFErrorResponse errorResponse, String orderId) {
    if (kDebugMode) {
      print("Payment failed for order: $orderId");
      print("Error: ${errorResponse.getMessage()}");
    }
    EasyLoading.dismiss();
    Get.snackbar(
      'Error',
      'Payment failed: ${errorResponse.getMessage()}',
      backgroundColor: Colors.red.shade50,
      colorText: Colors.red.shade900,
      margin: const EdgeInsets.all(16),
      borderRadius: 10,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> webCheckout({String? orderId, String? paymentSessionId}) async {
    try {
      var session =
          createSession(orderId: orderId, paymentSessionId: paymentSessionId);
      if (session == null) {
        throw CFException("Failed to create payment session");
      }

      final cfPaymentGatewayService = CFPaymentGatewayService();
      cfPaymentGatewayService.setCallback(
        (orderId) => onPaymentVerify(orderId),
        (errorResponse, orderId) => onPaymentError(errorResponse, orderId),
      );

      var cfWebCheckout = CFWebCheckoutPaymentBuilder().setSession(session);
      await cfPaymentGatewayService.doPayment(cfWebCheckout.build());
    } on CFException catch (e) {
      if (kDebugMode) {
        print("Cashfree Exception: ${e.message}");
      }
      EasyLoading.dismiss();
      Get.snackbar(
        'Error',
        'Payment initiation failed: ${e.message}',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Unexpected Error: $e");
      }
      EasyLoading.dismiss();
      Get.snackbar(
        'Error',
        'An unexpected error occurred during payment',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  CFSession? createSession({String? orderId, String? paymentSessionId}) {
    try {
      var session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.SANDBOX)
          .setOrderId(orderId ?? "")
          .setPaymentSessionId(paymentSessionId ?? "")
          .build();
      return session;
    } on CFException catch (e) {
      if (kDebugMode) {
        print("Session Creation Error: ${e.message}");
      }
      return null;
    }
  }

  void goToNextStep(BuildContext context) {
    if (activeStep.value < totalSteps - 1) {
      if (activeStep.value == 1 &&
          engagementModel.value != EngagementModel.saas) {
        showSuccessDialog(context);
      } else if (activeStep.value == 2 &&
          engagementModel.value == EngagementModel.saas) {
        activeStep.value = 3;
        debugPrint('Navigated to step ${activeStep.value} (Checkout for SaaS)');
      } else {
        activeStep.value++;
        debugPrint('Navigated to step ${activeStep.value}');
      }
    }
  }

  void goToPreviousStep() {
    if (activeStep.value > 0) {
      if (activeStep.value == 2 &&
          engagementModel.value != EngagementModel.saas) {
        activeStep.value = 1;
        debugPrint(
            'Navigated back to step ${activeStep.value} (from Details for non-SaaS)');
      } else if (activeStep.value == 3 &&
          engagementModel.value == EngagementModel.saas) {
        activeStep.value = 2;
        debugPrint(
            'Navigated back to step ${activeStep.value} (from Checkout for SaaS)');
      } else {
        activeStep.value--;
        debugPrint('Navigated to step ${activeStep.value}');
      }
    } else {
      selectedFlowType.value = null;
      Get.off(() => const MainScreen());
      debugPrint('Returned to MainScreen');
    }
    hasError.value = false;
  }

  void selectFlowType(FlowType type) {
    selectedFlowType.value = type;
    activeStep.value = 0;
    debugPrint('Selected flow: $type');
  }

  void selectEngagementModel(EngagementModel model, BuildContext context) {
    engagementModel.value = model;
    if (model != EngagementModel.saas) {
      productUserCounts.clear();
      userCountControllers.forEach((_, controller) => controller.text = '1');
    }
    goToNextStep(context);
    debugPrint('Selected engagement model: $model');
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
    totalPrice; // Update total
  }

  void updateUserCount(String productName, String count) {
    final intCount = int.tryParse(count) ?? 1;
    productUserCounts[productName] = intCount;
    debugPrint('Updated user count for $productName: $intCount');
  }

  Future<void> submitForm({
    required BuildContext context,
    bool isPayment = false,
    bool isAgreement = false,
  }) async {
    debugPrint(
      'submitForm called: step=${activeStep.value}, '
      'isPayment=$isPayment, isAgreement=$isAgreement, '
      'flowType=${selectedFlowType.value}, '
      'selectedProducts=$selectedProducts, '
      'engagementModel=${engagementModel.value}',
    );

    if (selectedFlowType.value == FlowType.product) {
      if (activeStep.value == 0 && engagementModel.value == null) {
        Get.snackbar(
          'Selection Required',
          'Please select an engagement model',
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          margin: const EdgeInsets.all(16),
          borderRadius: 10,
          snackPosition: SnackPosition.BOTTOM,
        );
        debugPrint('No engagement model selected in step 0');
        return;
      }
      if (activeStep.value == 1 && selectedProducts.isEmpty) {
        Get.snackbar(
          'Selection Required',
          'Please select at least one product',
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          margin: const EdgeInsets.all(16),
          borderRadius: 10,
          snackPosition: SnackPosition.BOTTOM,
        );
        debugPrint('No products selected in step 1');
        return;
      }
      if (activeStep.value == 2 &&
          engagementModel.value == EngagementModel.saas) {
        if (pricingFormKey.currentState != null &&
            !pricingFormKey.currentState!.validate()) {
          hasError.value = true;
          debugPrint(
              'Form validation failed at step ${activeStep.value} (pricing)');
          Get.snackbar(
            'Error',
            'Please fill all required fields correctly',
            backgroundColor: Colors.red.shade50,
            colorText: Colors.red.shade900,
            margin: const EdgeInsets.all(16),
            borderRadius: 10,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        if (productUserCounts.isEmpty ||
            productUserCounts.values.any((count) => count <= 0)) {
          Get.snackbar(
            'Input Required',
            'Please enter a valid number of users for each product',
            backgroundColor: Colors.red.shade50,
            colorText: Colors.red.shade900,
            margin: const EdgeInsets.all(16),
            borderRadius: 10,
            snackPosition: SnackPosition.BOTTOM,
          );
          debugPrint('Invalid user counts in step 2');
          return;
        }
      }
      if (activeStep.value == 3 &&
          engagementModel.value == EngagementModel.saas) {
        // Payment validation can be added here if needed
      }
      if (activeStep.value == 4 ||
          (activeStep.value == 2 &&
              engagementModel.value != EngagementModel.saas)) {
        if (contactFormKey.currentState != null &&
            !contactFormKey.currentState!.validate()) {
          hasError.value = true;
          debugPrint(
              'Form validation failed at step ${activeStep.value} (contact)');
          Get.snackbar(
            'Error',
            'Please fill all required fields correctly',
            backgroundColor: Colors.red.shade50,
            colorText: Colors.red.shade900,
            margin: const EdgeInsets.all(16),
            borderRadius: 10,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }
    } else if (selectedFlowType.value == FlowType.service) {
      if (serviceFormKey.currentState != null &&
          !serviceFormKey.currentState!.validate()) {
        hasError.value = true;
        debugPrint('Form validation failed in service flow');
        Get.snackbar(
          'Error',
          'Please fill all required fields correctly',
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          margin: const EdgeInsets.all(16),
          borderRadius: 10,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    isLoading.value = true;
    try {
      if (selectedFlowType.value == FlowType.service) {
        isSubmitted.value = true;
        showSuccessDialog(context);
        debugPrint('Service flow submitted');
      } else if (selectedFlowType.value == FlowType.product) {
        // Helper to get a valid plan for the product
        String getValidPlan(String productName, String? selectedPlan) {
          final plansAndPrices = getProductPlansAndPrices(productName);
          final availablePlans = plansAndPrices['plans'] as List<String>;
          if (selectedPlan == null || !availablePlans.contains(selectedPlan)) {
            // Return the first available plan as default
            return availablePlans.first;
          }
          return selectedPlan;
        }

        final formData = {
          'companyName': companyController.text,
          'fullName': nameController.text,
          'email': emailController.text,
          'phoneNumber': phoneController.text,
          'interestedIn': 'Product',
          'engagementModel': getApiEngagementModel(engagementModel.value),
          'selectedProducts': selectedProducts
              .map(
                (productName) => {
                  'productName': productName,
                  'planName':
                      getValidPlan(productName, productPlans[productName]),
                  if (engagementModel.value == EngagementModel.saas) ...{
                    'userCountRange': productUserRanges[productName] ?? '1-10',
                    'userCount': productUserCounts[productName] ?? 1,
                    'pricePerUser': getProductPlansAndPrices(
                            productName)['prices']
                        [getValidPlan(productName, productPlans[productName])],
                    'totalPrice':
                        (getProductPlansAndPrices(productName)['prices'][
                                    getValidPlan(
                                        productName, productPlans[productName])]
                                as double) *
                            (productUserCounts[productName] ?? 1),
                  },
                },
              )
              .toList(),
          if (engagementModel.value == EngagementModel.saas)
            'totalAmount': totalPrice.value,
        };
        if (kDebugMode) {
          print('data====>$formData');
        }

        if (activeStep.value == 0 ||
            activeStep.value == 1 ||
            activeStep.value == 2) {
          goToNextStep(context);
          debugPrint('Proceeding to next step: ${activeStep.value}');
        } else if (activeStep.value == 3 &&
            engagementModel.value == EngagementModel.saas &&
            isPayment) {
          final isSuccess = await sendUserData(formData);
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
            return;
          }
          isSubmitted.value = true;
          showSuccessDialog(context);
          debugPrint('SaaS payment flow submitted');
        } else if (activeStep.value == 2 &&
            engagementModel.value != EngagementModel.saas &&
            isAgreement) {
          final isSuccess = await sendUserData(formData);
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
            return;
          }
          isSubmitted.value = true;
          showSuccessDialog(context);
          debugPrint('Non-SaaS agreement flow submitted');
        } else if (activeStep.value == 4) {
          final isSuccess = await sendUserData(formData);
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
            return;
          }
          isSubmitted.value = true;
          showSuccessDialog(context);
          debugPrint('Product flow final step submitted');
        }
      }
      hasError.value = false;
    } catch (e) {
      hasError.value = true;
      debugPrint('Submission error: $e');
      Get.snackbar(
        'Error',
        'An error occurred. Please try again.',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      debugPrint(
          'submitForm completed: step=${activeStep.value}, selectedProducts=$selectedProducts');
    }
  }

  void showSuccessDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.2),
      pageBuilder: (context, animation1, animation2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white.withValues(alpha: 0.9),
              title: Text(
                'Thank You!',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F1C35),
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
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF404B69),
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
                      resetFlow();
                      Get.offAll(() => const MainScreen());
                    },
                    child: Text(
                      'OK',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2EC4F3),
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
  }
}
