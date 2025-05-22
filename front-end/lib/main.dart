import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nairobi_app/service/api_service.dart';
import 'package:nairobi_app/view/screens/check_out.dart';
import 'package:nairobi_app/view/screens/plan_feature_screen.dart';
import 'package:nairobi_app/view/widgets/policy_pages.dart';

void main() {

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'n"AI"robi BizTech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2EC4F3),
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2EC4F3),
          secondary: const Color(0xFFBFD633),
          tertiary: const Color(0xFF2EC4B6),
          surface: Colors.grey.shade500,
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.montserrat(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F1C35),
            letterSpacing: -0.5,
          ),
          displayMedium: GoogleFonts.montserrat(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F1C35),
          ),
          headlineLarge: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F1C35),
          ),
          headlineMedium: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F1C35),
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF404B69),
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF404B69),
          ),
          labelLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2EC4F3), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8E99B7),
          ),
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF404B69),
          ),
          floatingLabelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2EC4F3),
          ),
          errorStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFE53935),
          ),
          prefixIconColor: const Color(0xFF404B69),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: GoogleFonts.inter(
              fontSize: 16,

              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
            minimumSize: const Size(double.infinity, 54),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white.withValues(alpha: 0.9),
          surfaceTintColor: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          titleTextStyle: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F1C35),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF0F1C35)),
        ),
      ),
      home: const MainScreen(),
      builder: EasyLoading.init(),
    );
  }
}

enum FlowType { service, product }

enum EngagementModel { saas, reseller, partner, whitelabel }

class ProductInfo {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final double pricePerUser;

  ProductInfo({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.pricePerUser,
  });
}

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

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppController());
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Obx(
              () =>
          controller.isSubmitted.value
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

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;
  final List<Color> gradientColors;
  final double borderRadius;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.text,
    this.gradientColors = const [Color(0xFFBFD633), Color(0xFF2EC4F3)],
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: text,
      child: AbsorbPointer(
        absorbing: isLoading,
        child: GestureDetector(
          onTap: isLoading ? null : onPressed,
          child: Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                isLoading
                    ? [Colors.grey.shade300, Colors.grey.shade400]
                    : gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            alignment: Alignment.center,
            child:
            isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  RxString selectedOption = ''.obs;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    return Stack(
      children: [
        Container(decoration: BoxDecoration(color: Colors.grey.shade200)),
        Container(color: Colors.white.withValues(alpha: 0.1)),
        SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: controller.landingFormKey, // Use landingFormKey
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Center(child: SvgPicture.asset("assets/banner.svg")),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Lemolite Technologies LLP'),
                                  content: const Text(
                                    'Lemolite Technologies LLP is engaged in the development and sale of cloud-based enterprise software solutions. We offer Applicant Tracking Systems (ATS), Human Resource and Employee Management Systems (HREMS), Customer Relationship Management (CRM) platforms, and Inventory Management Systems (IMS).\n\n'
                                        'Our services are delivered under a subscription-based and white-label model, enabling businesses to use or resell our solutions under their own brand name. The products are accessible through secure web portals and are primarily used by SMEs and enterprises to streamline operations in hiring, HR management, sales and customer service, and inventory control.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: SvgPicture.asset(
                              "assets/lemologo.svg",
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'n"AI"robi BizTech',
                          style: GoogleFonts.montserrat(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F1C35),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'Get Started with n"AI"robi BizTech',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tell us about yourself to explore our solutions.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: controller.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator:
                          (value) =>
                      value == null || value.isEmpty
                          ? 'Please enter your name'
                          : null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.companyController,
                      decoration: const InputDecoration(
                        labelText: 'Company Name',
                        hintText: 'Enter your company name',
                        prefixIcon: Icon(Icons.business_outlined),
                      ),
                      validator:
                          (value) =>
                      value == null || value.isEmpty
                          ? 'Please enter your company name'
                          : null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'Enter your email address',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator:
                          (value) =>
                      value == null || value.isEmpty
                          ? 'Please enter your email'
                          : !value.contains('@') || !value.contains('.')
                          ? 'Please enter a valid email'
                          : null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator:
                          (value) =>
                      value == null || value.isEmpty
                          ? 'Please enter your phone number'
                          : null,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Interested In',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Obx(
                          () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: const Text('Service'),
                            leading: Radio<String>(
                              value: 'Service',
                              groupValue: selectedOption.value,
                              onChanged: (value) {
                                selectedOption.value = value!;
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Product'),
                            leading: Radio<String>(
                              value: 'Product',
                              groupValue: selectedOption.value,
                              onChanged: (value) {
                                selectedOption.value = value!;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Obx(() {
                      return GradientButton(
                        onPressed: () async {
                          if (controller.landingFormKey.currentState != null &&
                              controller.landingFormKey.currentState!
                                  .validate()) {
                            if (selectedOption.value == 'Service') {
                              final formData = {
                                'companyName':
                                controller.companyController.text,
                                'fullName': controller.nameController.text,
                                'email': controller.emailController.text,
                                'phoneNumber': controller.phoneController.text,
                                'interestedIn': 'Service',
                              };
                              if (kDebugMode) {
                                print('data====>$formData');
                              }
                              final isSuccess = await controller.sendUserData(
                                formData,
                              );
                              if (isSuccess) {
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
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          backgroundColor: Colors.white
                                              .withValues(alpha: 0.9),
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

                                                  // Get.offAll(
                                                  //       () => const SuccessScreen(),
                                                  // );
                                                },
                                                child: Text(
                                                  'OK',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
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
                              }

                              // Get.off(() => const ServiceRequestFlow());
                            } else if (selectedOption.value == 'Product') {
                              controller.selectFlowType(FlowType.product);
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
                        text:
                        selectedOption.value == 'Service'
                            ? 'Submit Request'
                            : 'Next',
                        gradientColors: const [
                          Color(0xFFBFD633),
                          Color(0xFF2EC4F3),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),
                    //create three buttons textbutton privacy policy, terms and conditions, and shiping policy
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(() => const PrivacyPolicyPage());
                          },
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(fontSize: 10.5),
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            Get.to(() => const TermsConditionsPage());
                          },
                          child: Text(
                            'Terms and Conditions',
                            style: TextStyle(fontSize: 10.5),
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            Get.to(() => const ShippingPolicyPage());
                          },
                          child: Text(
                            'Shipping Policy',
                            style: TextStyle(fontSize: 10.5),
                          ),
                        ),
                      ],
                    ),
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

class ServiceTypeSelector extends StatefulWidget {
  const ServiceTypeSelector({super.key});

  @override
  _ServiceTypeSelectorState createState() => _ServiceTypeSelectorState();
}

class _ServiceTypeSelectorState extends State<ServiceTypeSelector> {
  String? selectedService;

  final List<Map<String, dynamic>> serviceTypes = [
    {
      'title': 'Implementation',
      'icon': Icons.settings_outlined,
      'color': const Color(0xFF2EC4F3),
    },
    {
      'title': 'Consulting',
      'icon': Icons.lightbulb_outline,
      'color': const Color(0xFFBFD633),
    },
    {
      'title': 'Training',
      'icon': Icons.school_outlined,
      'color': const Color(0xFF2EC4B6),
    },
    {
      'title': 'Support',
      'icon': Icons.headset_mic_outlined,
      'color': const Color(0xFF2EC4F3),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Service Type', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
          serviceTypes.map((service) {
            final bool isSelected = selectedService == service['title'];
            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => selectedService = service['title']);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color:
                  isSelected
                      ? service['color'].withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                    isSelected
                        ? service['color']
                        : const Color(0xFFEAEEF5),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      service['icon'],
                      color:
                      isSelected
                          ? service['color']
                          : const Color(0xFF404B69),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      service['title'],
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:
                        isSelected
                            ? service['color']
                            : const Color(0xFF404B69),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

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
      body: Container(
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
                            'fullName': controller.nameController.text,
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

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final bool isActive = index == currentStep;
        final bool isCompleted = index < currentStep;
        final Color circleColor = isCompleted
            ? const Color(0xFF2EC4F3)
            : isActive
            ? const Color(0xFFBFD633)
            : const Color(0xFFEAEEF5);
        final Color textColor = isCompleted || isActive
            ? const Color(0xFF0F1C35)
            : const Color(0xFF8E99B7);

        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Step circle and connecting line
              Row(
                children: [
                  // Left connecting line (except for first step)
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index <= currentStep
                            ? const Color(0xFF2EC4F3)
                            : const Color(0xFFEAEEF5),
                      ),
                    ),
                  // Step circle
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: circleColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                          : Text(
                        '${index + 1}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? Colors.white
                              : const Color(0xFF8E99B7),
                        ),
                      ),
                    ),
                  ),
                  // Right connecting line (except for last step)
                  if (index < totalSteps - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index < currentStep
                            ? const Color(0xFF2EC4F3)
                            : const Color(0xFFEAEEF5),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Step label
              Text(
                labels[index],
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class EngagementModelStep extends StatelessWidget {
  const EngagementModelStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Engagement Model',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Choose how you\'d like to engage with our products.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 32),
        Obx(
              () => _buildEngagementOption(
            title: 'SaaS-Based Subscription',
            description: 'Cloud-based subscription with seamless updates',
            icon: Icons.cloud_outlined,
            color: const Color(0xFF2EC4F3),
            isSelected:
            controller.engagementModel.value == EngagementModel.saas,
            onTap: () {
              HapticFeedback.lightImpact();
              controller.selectEngagementModel(EngagementModel.saas, context);
            },
          ),
        ),
        const SizedBox(height: 16),
        Obx(
              () => _buildEngagementOption(
            title: 'Reseller',
            description: 'Distribute our products under your brand',
            icon: Icons.store_outlined,
            color: const Color(0xFFBFD633),
            isSelected:
            controller.engagementModel.value == EngagementModel.reseller,
            onTap: () {
              HapticFeedback.lightImpact();
              controller.selectEngagementModel(
                EngagementModel.reseller,
                context,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Obx(
              () => _buildEngagementOption(
            title: 'Partner',
            description: 'Collaborate to integrate solutions',
            icon: Icons.handshake_outlined,
            color: const Color(0xFF2EC4B6),
            isSelected:
            controller.engagementModel.value == EngagementModel.partner,
            onTap: () {
              HapticFeedback.lightImpact();
              controller.selectEngagementModel(
                EngagementModel.partner,
                context,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Obx(
              () => _buildEngagementOption(
            title: 'Whitelabel',
            description: 'Customize and brand our solutions as your own',
            icon: Icons.branding_watermark_outlined,
            color: const Color(0xFF2EC4F3),
            isSelected:
            controller.engagementModel.value == EngagementModel.whitelabel,
            onTap: () {
              HapticFeedback.lightImpact();
              controller.selectEngagementModel(
                EngagementModel.whitelabel,
                context,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEngagementOption({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? color : const Color(0xFFEAEEF5),
          width: isSelected ? 2 : 1,
        ),
        boxShadow:
        isSelected
            ? [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 32, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F1C35),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF404B69),
                        ),
                      ),
                    ],
                  ),
                ),
                Semantics(
                  label: title,
                  child: Radio(
                    value: true,
                    groupValue: isSelected,
                    onChanged: (_) => onTap(),
                    activeColor: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductSelectionStep extends StatelessWidget {
  const ProductSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();
    final products = controller.productsList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Products',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the products you\'re interested in.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Obx(() {
              final isSelected = controller.selectedProducts.contains(
                product.name,
              );
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  controller.toggleProduct(product.name);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                      isSelected ? product.color : const Color(0xFFEAEEF5),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow:
                    isSelected
                        ? [
                      BoxShadow(
                        color: product.color.withValues(alpha: 0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ]
                        : [],
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: product.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                product.icon,
                                size: 28,
                                color: product.color,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              product.name,
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0F1C35),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: Text(
                                product.description,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF404B69),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: product.color,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            });
          },
        ),
      ],
    );
  }
}

class PlanPricingStep extends StatelessWidget {
  const PlanPricingStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();
    final plans = ['Free', 'Essential', 'Enterprise'];

    return Obx(() {
      final isSaaS = controller.engagementModel.value == EngagementModel.saas;
      final selectedProducts = controller.selectedProducts;
      debugPrint(
        'PlanPricingStep: isSaaS=$isSaaS, selectedProducts=$selectedProducts',
      );

      return Form(
        key: controller.pricingFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isSaaS ? 'Plan & Pricing' : 'Service Agreement',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isSaaS
                  ? 'Select a plan and specify the number of users for each product.'
                  : 'Submit to request a service agreement for your selected model.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            if (isSaaS) ...[
              ...selectedProducts.map((productName) {
                final product = controller.productsList.firstWhere(
                      (p) => p.name == productName,
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F1C35),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Obx(() {
                          //   final selectedPlan =
                          //       controller.productPlans[productName] ?? 'Free';
                          //   return Text(
                          //     'Price: ₹${controller.getPriceForPlan(productName, selectedPlan)}/user/month',
                          //     style: Theme.of(context).textTheme.bodyMedium,
                          //   );
                          // }),
                          const SizedBox(height: 16),
                          Obx(() {
                            return DropdownButtonFormField<String>(
                              dropdownColor: Colors.white,
                              value: controller.productPlans[productName] ?? plans[0],
                              decoration: InputDecoration(
                                labelText: 'Plan',
                                prefixIcon: Icon(
                                  Icons.card_membership_outlined,
                                  color: selectedProducts.indexOf(productName) % 2 == 0
                                      ? const Color(0xFFBFD633)
                                      : const Color(0xFF2EC4F3),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              items: plans.map((plan) {
                                return DropdownMenuItem<String>(
                                  value: plan,
                                  child: Text(plan),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  controller.updatePlan(productName, value);
                                  debugPrint('Selected plan for $productName: $value');
                                }
                              },
                              validator: (value) =>
                              value == null ? 'Please select a plan' : null,
                            );
                          }),
                          // const SizedBox(height: 16),
                          // Obx(() {
                          //   final selectedPlan =
                          //       controller.productPlans[productName] ?? 'Free';
                          //   return TextFormField(
                          //     controller: controller.userCountControllers[productName],
                          //     keyboardType: TextInputType.number,
                          //     decoration: InputDecoration(
                          //       labelText: 'No. of Users',
                          //       prefixIcon: Icon(
                          //         Icons.group_outlined,
                          //         color: selectedProducts.indexOf(productName) % 2 == 0
                          //             ? const Color(0xFFBFD633)
                          //             : const Color(0xFF2EC4F3),
                          //       ),
                          //       border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(12),
                          //       ),
                          //       contentPadding: const EdgeInsets.symmetric(
                          //         horizontal: 16,
                          //         vertical: 12,
                          //       ),
                          //     ),
                          //     enabled: selectedPlan != 'Free',
                          //     validator: (value) {
                          //       if (selectedPlan == 'Free' && (value == null || value.isEmpty)) {
                          //         return null;
                          //       }
                          //       if (value == null || value.isEmpty) {
                          //         return 'Please enter the number of users';
                          //       }
                          //       final count = int.tryParse(value);
                          //       if (count == null || count <= 0) {
                          //         return 'Please enter a valid number';
                          //       }
                          //       if (selectedPlan == 'Essential' && count > 50) {
                          //         return 'Essential plan supports up to 50 users';
                          //       }
                          //       if (selectedPlan == 'Enterprise' && count < 51) {
                          //         return 'Enterprise plan requires 51+ users';
                          //       }
                          //       return null;
                          //     },
                          //     onChanged: (value) {
                          //       controller.updateUserCount(productName, value);
                          //       debugPrint('Updated user count for $productName: $value');
                          //     },
                          //   );
                          // }),
                          const SizedBox(height: 16),
                          // Obx(() {
                          //   final selectedPlan =
                          //       controller.productPlans[productName] ?? 'Free';
                          //   final userCount =
                          //       controller.productUserCounts[productName] ?? 1;
                          //   final price = controller.getPriceForPlan(
                          //     productName,
                          //     selectedPlan,
                          //   ) *
                          //       userCount;
                          //   return Text(
                          //     'Total: ₹${price.toStringAsFixed(2)}/month',
                          //     style: GoogleFonts.inter(
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.w600,
                          //       color: selectedProducts.indexOf(productName) % 2 == 0
                          //           ? const Color(0xFFBFD633)
                          //           : const Color(0xFF2EC4F3),
                          //     ),
                          //   );
                          // }),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => PlanFeaturesScreen(
                                  productName: productName,
                                ));
                              },
                              child: Text(
                                'See Features',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Grand Total',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F1C35),
                        ),
                      ),
                      Obx(
                            () => Text(
                          '₹${controller.totalPrice.toStringAsFixed(2)}/month',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2EC4F3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Request Service Agreement',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F1C35),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selected Products: ${selectedProducts.join(', ')}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Our team will contact you to discuss the service agreement details for the ${controller.engagementModel.value!.toString().split('.').last} model.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class ContactDetailsStep extends StatelessWidget {
  const ContactDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    return Form(
      key: controller.contactFormKey, // Changed: Use contactFormKey
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Review and update your details.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          ContactForm(
            formKey: controller.contactFormKey,
            nameController: controller.nameController,
            emailController: controller.emailController,
            companyController: controller.companyController,
            phoneController: controller.phoneController,
            messageController: controller.messageController,
            messageLabel: 'Additional Comments',
            messagePlaceholder:
            'Share any specific requirements or questions...',
          ),
        ],
      ),
    );
  }
}

class ContactForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController companyController;
  final TextEditingController phoneController;
  final TextEditingController messageController;
  final String messageLabel;
  final String messagePlaceholder;

  const ContactForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.companyController,
    required this.phoneController,
    required this.messageController,
    required this.messageLabel,
    required this.messagePlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            hintText: 'Enter your full name',
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator:
              (value) =>
          value == null || value.isEmpty
              ? 'Please enter your name'
              : null,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: companyController,
          decoration: const InputDecoration(
            labelText: 'Company Name',
            hintText: 'Enter your company name',
            prefixIcon: Icon(Icons.business_outlined),
          ),
          validator:
              (value) =>
          value == null || value.isEmpty
              ? 'Please enter your company name'
              : null,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter your email address',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          validator:
              (value) =>
          value == null || value.isEmpty
              ? 'Please enter your email'
              : !value.contains('@') || !value.contains('.')
              ? 'Please enter a valid email'
              : null,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: 'Enter your phone number',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
          validator:
              (value) =>
          value == null || value.isEmpty
              ? 'Please enter your phone number'
              : null,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: messageController,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: messageLabel,
            hintText: messagePlaceholder,
            alignLabelWithHint: true,
          ),
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Container(
          color: Colors.white.withValues(alpha: 0.1),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBFD633).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFBFD633).withValues(alpha: 0.1),
                          blurRadius: 50,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Color(0xFFBFD633),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Thank You!',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.selectedFlowType.value == FlowType.service
                        ? 'Your service request has been submitted successfully.'
                        : controller.engagementModel.value ==
                        EngagementModel.saas
                        ? 'Your payment has been processed successfully.'
                        : 'Your request for a service agreement has been submitted.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.engagementModel.value == EngagementModel.saas ||
                        controller.selectedFlowType.value ==
                            FlowType.service
                        ? 'Our team will contact you soon at ${controller.emailController.text}'
                        : 'We’ll get in touch with the agreement details at ${controller.emailController.text}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 24,
                  //     vertical: 16,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white.withValues(alpha:0.9),
                  //     borderRadius: BorderRadius.circular(16),
                  //     border: Border.all(color: const Color(0xFF2EC4F3)),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       Text(
                  //         'Reference Number',
                  //         style: GoogleFonts.inter(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w500,
                  //           color: const Color(0xFF404B69),
                  //         ),
                  //       ),
                  //       const SizedBox(height: 4),
                  //       Text(
                  //         'LL${DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13)}',
                  //         style: GoogleFonts.montserrat(
                  //           fontSize: 24,
                  //           fontWeight: FontWeight.w600,
                  //           color: const Color(0xFF0F1C35),
                  //           letterSpacing: 1.5,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 48),
                  GradientButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      controller.resetFlow();
                      Get.offAll(
                            () => const MainScreen(),
                      ); // Changed: Reset navigation stack
                    },
                    isLoading: false,
                    text: 'Return to Home',
                    gradientColors: const [
                      Color(0xFFBFD633),
                      Color(0xFF2EC4F3),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
