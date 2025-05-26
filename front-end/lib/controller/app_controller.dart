import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/enums.dart';
import '../models/product_info.dart';
import '../service/api_service.dart';
import '../view/screens/main_screen.dart';

class AppController extends GetxController {
  final RxMap<String, String> productPlans = <String, String>{}.obs; // Renamed
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
  RxString selectedPlan = 'Free'.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();

  final landingFormKey = GlobalKey<FormState>();
  final serviceFormKey = GlobalKey<FormState>();
  final pricingFormKey = GlobalKey<FormState>();
  final contactFormKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> userCountControllers = {};

  void updatePlan(String productName, String plan) {
    productPlans[productName] = plan;
    // Set default user count based on plan
    int minUsers = plan == 'Free' ? 1 : (plan == 'Essential' ? 1 : 51);
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
      pricePerUser: 500.0,
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
    selectedFlowType.value = null;
    engagementModel.value = null;
    selectedProducts.clear();
    productUserCounts.clear();
    productUserRanges.clear();
    savedCards.clear();
    nameController.clear();
    emailController.clear();
    companyController.clear();
    phoneController.clear();
    messageController.clear();
    userCountControllers.forEach((_, controller) => controller.text = '1');
    isSubmitted.value = false;
    hasError.value = false;
    activeStep.value = 0;
    isLoading.value = false;
    for (var product in productsList) {
      productUserRanges[product.name] = '1-10';
    }
    debugPrint('Flow reset');
  }

  Future<bool> sendUserData(Map<String, dynamic> data2) async {
    // Helper function to convert RxDouble to double recursively
    Map<String, dynamic> convertRxDoubleToDouble(Map<String, dynamic> data) {
      final converted = <String, dynamic>{};
      data.forEach((key, value) {
        if (value is RxDouble) {
          converted[key] = value.value; // Convert RxDouble to double
        } else if (value is List) {
          converted[key] =
              value.map((item) {
                if (item is Map<String, dynamic>) {
                  return convertRxDoubleToDouble(
                    item,
                  ); // Recursively convert nested maps
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

    // Calculate totalAmount from selectedProducts
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

      // Convert RxDouble to double
      final convertedData = convertRxDoubleToDouble(data2);

      // Update totalAmount
      convertedData['totalAmount'] = calculateTotalAmount(convertedData);

      if (kDebugMode) {
        print('body====>$convertedData');
      }

      final response = await ApiService.post(
        convertedData,
        'https://events.lemolite360.in/api/leads',
      );

      if (response != null &&
          (response.statusCode == 201 || response.statusCode == 200)) {
        if (kDebugMode) {
          print('response=======>${response.data}');
        }
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

  void goToNextStep(BuildContext context) {
    if (activeStep.value < totalSteps - 1) {
      if (activeStep.value == 1 &&
          engagementModel.value != EngagementModel.saas) {
        // activeStep.value = 2;
        // debugPrint(
        //   'Navigated to step ${activeStep.value} (skipped Pricing for non-SaaS)',
        // );
        showSuccessDialog(context);
        // final isSuccess = await sendUserData(formData);
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
          'Navigated back to step ${activeStep.value} (from Details for non-SaaS)',
        );
      } else if (activeStep.value == 3 &&
          engagementModel.value == EngagementModel.saas) {
        activeStep.value = 2;
        debugPrint(
          'Navigated back to step ${activeStep.value} (from Checkout for SaaS)',
        );
      } else {
        activeStep.value--;
        debugPrint('Navigated back to step ${activeStep.value}');
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

  void updateUserCount(String productName, String value) {
    final count = int.tryParse(value) ?? 1;
    if (count > 0) {
      productUserCounts[productName] = count;
    } else {
      productUserCounts.remove(productName);
      selectedProducts.remove(productName);
      userCountControllers[productName]!.text = '1';
    }
    totalPrice; // Update total
  }

  // Future<void> processPayment() async {
  //   try {
  //     final paymentData = {
  //       'email': emailController.text,
  //       'amount': totalPrice * 100, // Convert to paise for INR
  //       'currency': 'INR',
  //       'products':
  //           selectedProducts
  //               .map(
  //                 (p) => {
  //                   'name': p,
  //                   'users': productUserCounts[p] ?? 1,
  //                   'pricePerUser':
  //                       productsList
  //                           .firstWhere((prod) => prod.name == p)
  //                           .pricePerUser,
  //                 },
  //               )
  //               .toList(),
  //       'referenceNumber':
  //           'LL${DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13)}',
  //       'card': savedCards.isNotEmpty ? savedCards.first : null,
  //     };
  //
  //     debugPrint('Processing payment: $paymentData');
  //     final response = await http.post(
  //       Uri.parse('https://api.example.com/process-payment'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(paymentData),
  //     );
  //
  //     if (response.statusCode != 200) {
  //       throw Exception('Payment failed: ${response.body}');
  //     }
  //     debugPrint('Payment successful');
  //   } catch (e) {
  //     debugPrint('Payment error: $e');
  //     Get.snackbar(
  //       'Error',
  //       'Payment processing failed. Please try again.',
  //       backgroundColor: Colors.red.shade50,
  //       colorText: Colors.red.shade900,
  //       margin: const EdgeInsets.all(16),
  //       borderRadius: 10,
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //     rethrow;
  //   }
  // }

  //   Future<void> sendEmails({
  //     bool isPayment = false,
  //     bool isAgreement = false,
  //   }) async {
  //     final String flow =
  //         selectedFlowType.value == FlowType.service
  //             ? 'Service Request'
  //             : 'Product Inquiry';
  //     final String referenceNumber =
  //         'LL${DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13)}';
  //     final Map<String, dynamic> formData = {
  //       'flow': flow,
  //       'name': nameController.text,
  //       'email': emailController.text,
  //       'company': companyController.text,
  //       'phone': phoneController.text,
  //       'message': messageController.text,
  //       'engagementModel': engagementModel.value?.toString().split('.').last,
  //       'selectedProducts':
  //           selectedProducts
  //               .map(
  //                 (p) => {
  //                   'name': p,
  //                   if (engagementModel.value == EngagementModel.saas)
  //                     'users': productUserCounts[p] ?? 1,
  //                   if (engagementModel.value == EngagementModel.saas)
  //                     'pricePerUser':
  //                         productsList
  //                             .firstWhere((prod) => prod.name == p)
  //                             .pricePerUser,
  //                 },
  //               )
  //               .toList(),
  //       'totalPrice': isPayment ? totalPrice : null,
  //       'referenceNumber': referenceNumber,
  //       'timestamp': DateTime.now().toIso8601String(),
  //     };
  //
  //     try {
  //       final internalEmail = {
  //         'to': 'sales@lemolite.com',
  //         'subject': '$flow Submission - $referenceNumber',
  //         'body': '''
  // New $flow Submission
  // Reference: $referenceNumber
  // Name: ${formData['name']}
  // Email: ${formData['email']}
  // Company: ${formData['company']}
  // Phone: ${formData['phone']}
  // Message: ${formData['message']}
  // ${flow == 'Product Inquiry' ? 'Engagement Model: ${formData['engagementModel']}\nProducts: ${formData['selectedProducts'].map((p) => '${p['name']} ${p['users'] != null ? '(${p['users']} users @ ₹${p['pricePerUser']}/user/month)' : ''}').join(', ')}' : ''}
  // ${isPayment
  //             ? 'Total Paid: ₹${formData['totalPrice']}'
  //             : isAgreement
  //             ? 'Service Agreement Requested'
  //             : ''}
  // Submitted: ${formData['timestamp']}
  //         ''',
  //       };
  //
  //       final userEmail = {
  //         'to': formData['email'],
  //         'subject': 'nAIrobi $flow Confirmation - $referenceNumber',
  //         'body': '''
  // Dear ${formData['name']},
  //
  // Thank you for your $flow with nAIrobi. ${isPayment
  //             ? 'Your payment has been processed successfully.'
  //             : isAgreement
  //             ? 'We will get in touch with the service agreement details.'
  //             : 'We have received your submission and will contact you soon.'}
  //
  // Reference Number: $referenceNumber
  // ${flow == 'Product Inquiry' ? 'Engagement Model: ${formData['engagementModel']}\nSelected Products: ${formData['selectedProducts'].map((p) => '${p['name']} ${p['users'] != null ? '(${p['users']} users)' : ''}').join(', ')}' : 'Service Requirements: ${formData['message']}'}
  // ${isPayment ? 'Total Paid: ₹${formData['totalPrice']}' : ''}
  //
  // Best regards,
  // nAIrobi Team
  //         ''',
  //       };
  //
  //       debugPrint('Sending emails: $internalEmail, $userEmail');
  //       final response = await http.post(
  //         Uri.parse('https://api.example.com/send-email'),
  //         headers: {'Content-Type': 'application/json'},
  //         body: jsonEncode({
  //           'emails': [internalEmail, userEmail],
  //         }),
  //       );
  //
  //       if (response.statusCode != 200) {
  //         throw Exception('Failed to send emails: ${response.body}');
  //       }
  //       debugPrint('Emails sent successfully');
  //     } catch (e) {
  //       debugPrint('Email error: $e');
  //       Get.snackbar(
  //         'Error',
  //         'Failed to send confirmation emails. Please try again.',
  //         backgroundColor: Colors.red.shade50,
  //         colorText: Colors.red.shade900,
  //         margin: const EdgeInsets.all(16),
  //         borderRadius: 10,
  //         snackPosition: SnackPosition.BOTTOM,
  //       );
  //       rethrow;
  //     }
  //   }

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
            'Form validation failed at step ${activeStep.value} (pricing)',
          );
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
        // if (savedCards.isEmpty) {
        //   Get.snackbar(
        //     'Payment Method Required',
        //     'Please add at least one payment card to proceed',
        //     backgroundColor: Colors.red.shade50,
        //     colorText: Colors.red.shade900,
        //     margin: const EdgeInsets.all(16),
        //     borderRadius: 10,
        //     snackPosition: SnackPosition.BOTTOM,
        //   );
        //   debugPrint('No payment cards added in checkout step');
        //   return;
        // }
      }
      if (activeStep.value == 4 ||
          (activeStep.value == 2 &&
              engagementModel.value != EngagementModel.saas)) {
        if (contactFormKey.currentState != null &&
            !contactFormKey.currentState!.validate()) {
          hasError.value = true;
          debugPrint(
            'Form validation failed at step ${activeStep.value} (contact)',
          );
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
        // await sendEmails();
        isSubmitted.value = true;
        showSuccessDialog(context);
        debugPrint('Service flow submitted');
      } else if (selectedFlowType.value == FlowType.product) {
        // Prepare form data for API call
        final formData = {
          'companyName': companyController.text,
          'fullName': nameController.text,
          'email': emailController.text,
          'phoneNumber': phoneController.text,
          'interestedIn': 'Product',
          'engagementModel': getApiEngagementModel(engagementModel.value),
          'selectedProducts':
          selectedProducts
              .map(
                (productName) => {
              'productName': productName,
              if (engagementModel.value == EngagementModel.saas)
                'userCountRange':
                productUserRanges[productName] ?? '1-10',
              if (engagementModel.value == EngagementModel.saas)
                'totalPrice':
                productsList
                    .firstWhere((p) => p.name == productName)
                    .pricePerUser *
                    (productUserCounts[productName] ?? 1),
            },
          )
              .toList(),
          if (engagementModel.value == EngagementModel.saas)
            'totalAmount': totalPrice,
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
          // await processPayment();
          // await sendEmails(isPayment: true);
          // Send API data after successful payment
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
        } else if ((activeStep.value == 2 &&
            engagementModel.value != EngagementModel.saas) &&
            isAgreement) {
          // await sendEmails(isAgreement: true);
          // Send API data for non-SaaS agreement
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
          // Send API data for SaaS final step
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
        'submitForm completed: step=${activeStep.value}, selectedProducts=$selectedProducts',
      );
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