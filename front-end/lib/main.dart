import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  const MyApp({Key? key}) : super(key: key);

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
          background: Colors.grey.shade500,
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
          fillColor: Colors.white.withOpacity(0.9),
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
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white.withOpacity(0.9),
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
    );
  }
}

// Enums
enum FlowType { service, product }

enum EngagementModel { saas, reseller, partner, whitelabel }

// ProductInfo class
class ProductInfo {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final double pricePerUser; // Price in INR per user per month

  ProductInfo({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.pricePerUser,
  });
}

// Controller
class AppController extends GetxController {
  final Rx<FlowType?> selectedFlowType = Rx<FlowType?>(null);
  final Rx<EngagementModel?> engagementModel = Rx<EngagementModel?>(null);
  final RxList<String> selectedProducts = <String>[].obs;
  final RxMap<String, int> productUserCounts = <String, int>{}.obs;
  final RxBool isSubmitted = false.obs;
  final RxBool hasError = false.obs;
  final RxInt activeStep = 0.obs;
  final RxBool isLoading = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();

  // Separate GlobalKeys for each form
  final landingFormKey = GlobalKey<FormState>();
  final serviceFormKey = GlobalKey<FormState>();
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
    ProductInfo(
      name: 'Nexstaff',
      description: 'Comprehensive workforce management platform',
      icon: Icons.people_outline,
      color: const Color(0xFFBFD633),
      pricePerUser: 300.0,
    ),
    ProductInfo(
      name: 'Integrated (S2H+Nexstaff)',
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

  double get totalPrice {
    double total = 0.0;
    for (var productName in selectedProducts) {
      final product = productsList.firstWhere((p) => p.name == productName);
      final userCount = productUserCounts[productName] ?? 1;
      total += product.pricePerUser * userCount;
    }
    return total;
  }

  int get totalSteps => engagementModel.value == EngagementModel.saas ? 4 : 3;

  @override
  void onInit() {
    super.onInit();
    for (var product in productsList) {
      userCountControllers[product.name] = TextEditingController(text: '1');
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
    debugPrint('Flow reset');
  }

  void goToNextStep() {
    if (activeStep.value < totalSteps - 1) {
      if (activeStep.value == 1 &&
          engagementModel.value != EngagementModel.saas) {
        activeStep.value = 3; // Skip to ContactDetailsStep for non-saas
        debugPrint(
          'Navigated to step ${activeStep.value} (skipped Pricing for non-saas)',
        );
      } else {
        activeStep.value++;
        debugPrint('Navigated to step ${activeStep.value}');
      }
    }
  }

  void goToPreviousStep() {
    if (activeStep.value > 0) {
      if (activeStep.value == 3 &&
          engagementModel.value != EngagementModel.saas) {
        activeStep.value = 1; // Go back to ProductSelectionStep for non-saas
        debugPrint(
          'Navigated back to step ${activeStep.value} (from Details for non-saas)',
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

  void selectEngagementModel(EngagementModel model) {
    engagementModel.value = model;
    if (model != EngagementModel.saas) {
      productUserCounts.clear();
      userCountControllers.forEach((_, controller) => controller.text = '1');
    }
    goToNextStep();
    debugPrint('Selected engagement model: $model');
  }

  void toggleProduct(String productName) {
    if (selectedProducts.contains(productName)) {
      selectedProducts.remove(productName);
      productUserCounts.remove(productName);
      userCountControllers[productName]!.text = '1';
      debugPrint('Removed product: $productName');
    } else {
      selectedProducts.add(productName);
      productUserCounts[productName] =
          int.tryParse(userCountControllers[productName]!.text) ?? 1;
      debugPrint('Added product: $productName');
    }
    selectedProducts.refresh();
    debugPrint(
      'Toggled product: $productName, Selected: $selectedProducts, Length: ${selectedProducts.length}',
    );
  }

  void updateUserCount(String productName, String value) {
    final count = int.tryParse(value) ?? 1;
    if (count > 0) {
      productUserCounts[productName] = count;
      debugPrint('Updated user count for $productName: $count');
    } else {
      productUserCounts.remove(productName);
      selectedProducts.remove(productName);
      userCountControllers[productName]!.text = '1';
      debugPrint('Removed $productName due to invalid user count');
    }
  }

  Future<void> processPayment() async {
    try {
      final paymentData = {
        'email': emailController.text,
        'amount': totalPrice * 100,
        'currency': 'INR',
        'products':
            selectedProducts
                .map(
                  (p) => {
                    'name': p,
                    'users': productUserCounts[p] ?? 1,
                    'pricePerUser':
                        productsList
                            .firstWhere((prod) => prod.name == p)
                            .pricePerUser,
                  },
                )
                .toList(),
        'referenceNumber':
            'LL${DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13)}',
      };

      debugPrint('Processing payment: $paymentData');
      final response = await http.post(
        Uri.parse('https://api.example.com/process-payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(paymentData),
      );

      if (response.statusCode != 200) {
        throw Exception('Payment failed: ${response.body}');
      }
      debugPrint('Payment successful');
    } catch (e) {
      debugPrint('Payment error: $e');
      Get.snackbar(
        'Error',
        'Payment processing failed. Please try again.',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  Future<void> sendEmails({
    bool isPayment = false,
    bool isAgreement = false,
  }) async {
    final String flow =
        selectedFlowType.value == FlowType.service
            ? 'Service Request'
            : 'Product Inquiry';
    final String referenceNumber =
        'LL${DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13)}';
    final Map<String, dynamic> formData = {
      'flow': flow,
      'name': nameController.text,
      'email': emailController.text,
      'company': companyController.text,
      'phone': phoneController.text,
      'message': messageController.text,
      'engagementModel': engagementModel.value?.toString().split('.').last,
      'selectedProducts':
          selectedProducts
              .map(
                (p) => {
                  'name': p,
                  if (engagementModel.value == EngagementModel.saas)
                    'users': productUserCounts[p] ?? 1,
                  if (engagementModel.value == EngagementModel.saas)
                    'pricePerUser':
                        productsList
                            .firstWhere((prod) => prod.name == p)
                            .pricePerUser,
                },
              )
              .toList(),
      'totalPrice': isPayment ? totalPrice : null,
      'referenceNumber': referenceNumber,
      'timestamp': DateTime.now().toIso8601String(),
    };

    try {
      final internalEmail = {
        'to': 'sales@lemolite.com',
        'subject': '$flow Submission - $referenceNumber',
        'body': '''
New $flow Submission
Reference: $referenceNumber
Name: ${formData['name']}
Email: ${formData['email']}
Company: ${formData['company']}
Phone: ${formData['phone']}
Message: ${formData['message']}
${flow == 'Product Inquiry' ? 'Engagement Model: ${formData['engagementModel']}\nProducts: ${formData['selectedProducts'].map((p) => '${p['name']} ${p['users'] != null ? '(${p['users']} users @ ₹${p['pricePerUser']}/user/month)' : ''}').join(', ')}' : ''}
${isPayment
            ? 'Total Paid: ₹${formData['totalPrice']}'
            : isAgreement
            ? 'Service Agreement Requested'
            : ''}
Submitted: ${formData['timestamp']}
        ''',
      };

      final userEmail = {
        'to': formData['email'],
        'subject': 'nAIrobi $flow Confirmation - $referenceNumber',
        'body': '''
Dear ${formData['name']},

Thank you for your $flow with nAIrobi. ${isPayment
            ? 'Your payment has been processed successfully.'
            : isAgreement
            ? 'We will get in touch with the service agreement details.'
            : 'We have received your submission and will contact you soon.'}

Reference Number: $referenceNumber
${flow == 'Product Inquiry' ? 'Engagement Model: ${formData['engagementModel']}\nSelected Products: ${formData['selectedProducts'].map((p) => '${p['name']} ${p['users'] != null ? '(${p['users']} users)' : ''}').join(', ')}' : 'Service Requirements: ${formData['message']}'}
${isPayment ? 'Total Paid: ₹${formData['totalPrice']}' : ''}

Best regards,
nAIrobi Team
        ''',
      };

      debugPrint('Sending emails: $internalEmail, $userEmail');
      final response = await http.post(
        Uri.parse('https://api.example.com/send-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'emails': [internalEmail, userEmail],
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send emails: ${response.body}');
      }
      debugPrint('Emails sent successfully');
    } catch (e) {
      debugPrint('Email error: $e');
      Get.snackbar(
        'Error',
        'Failed to send confirmation emails. Please try again.',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
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

    // Validate forms based on the current step and flow
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
      if (activeStep.value == 3 ||
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
        await sendEmails();
        isSubmitted.value = true;
        showSuccessDialog(context);
        debugPrint('Service flow submitted');
      } else if (selectedFlowType.value == FlowType.product) {
        if (activeStep.value == 0 || activeStep.value == 1) {
          goToNextStep();
          debugPrint('Proceeding to next step: ${activeStep.value}');
        } else if (activeStep.value == 2 &&
            engagementModel.value == EngagementModel.saas &&
            isPayment) {
          await processPayment();
          await sendEmails(isPayment: true);
          isSubmitted.value = true;
          showSuccessDialog(context);
          debugPrint('SaaS payment flow submitted');
        } else if ((activeStep.value == 1 || activeStep.value == 2) &&
            isAgreement) {
          await sendEmails(isAgreement: true);
          isSubmitted.value = true;
          showSuccessDialog(context);
          debugPrint('Non-SaaS agreement flow submitted');
        } else if (activeStep.value == 3) {
          await sendEmails();
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
      barrierColor: Colors.black.withOpacity(0.2),
      pageBuilder: (context, animation1, animation2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white.withOpacity(0.9),
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
  const MainScreen({Key? key}) : super(key: key);

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
    Key? key,
    required this.onPressed,
    required this.isLoading,
    required this.text,
    this.gradientColors = const [Color(0xFFBFD633), Color(0xFF2EC4F3)],
    this.borderRadius = 12,
  }) : super(key: key);

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
        Container(color: Colors.white.withOpacity(0.1)),
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
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            size: 24,
                            color: Color(0xFF2EC4F3),
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
                        onPressed: () {
                          if (controller.landingFormKey.currentState != null &&
                              controller.landingFormKey.currentState!
                                  .validate()) {
                            if (selectedOption.value == 'Service') {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: '',
                                barrierColor: Colors.black.withOpacity(0.2),
                                pageBuilder: (context, animation1, animation2) {
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
                                            .withOpacity(0.9),
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
                    const SizedBox(height: 32),
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
  const ServiceRequestFlow({Key? key}) : super(key: key);

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
          color: Colors.white.withOpacity(0.1),
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
                                      barrierColor: Colors.black.withOpacity(
                                        0.2,
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
                                                  .withOpacity(0.9),
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
  const ServiceTypeSelector({Key? key}) : super(key: key);

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
                              ? service['color'].withOpacity(0.1)
                              : Colors.white.withOpacity(0.9),
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
  const ProductInquiryFlow({Key? key}) : super(key: key);

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
          color: Colors.white.withOpacity(0.1),
          child: SafeArea(
            child: Obx(() {
              final int activeStep = controller.activeStep.value;
              final bool isSaaS =
                  controller.engagementModel.value == EngagementModel.saas;
              final int totalSteps = isSaaS ? 4 : 3;
              final List<String> labels =
                  isSaaS
                      ? const ['Model', 'Products', 'Pricing', 'Details']
                      : const ['Model', 'Products', 'Details'];
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
                      void showSuccessDialog(BuildContext context) {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: '',
                          barrierColor: Colors.black.withOpacity(0.2),
                          pageBuilder: (context, animation1, animation2) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Center(
                                child: AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  backgroundColor: Colors.white.withOpacity(
                                    0.9,
                                  ),
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

                                          Get.offAll(
                                            () => const SuccessScreen(),
                                          );
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

                        buttonText = 'Proceed to Payment';
                        isPayment = true;
                      } else if (activeStep == 3 ||
                          (activeStep == 2 && !isSaaS)) {
                        buttonText = 'Submit Inquiry';
                      }

                      // onPressed =
                      //     canProceed && !controller.isLoading.value
                      //         ? () {
                      //           showSuccessDialog(context);
                      //         }
                      //         : null;
                      onPressed =
                          canProceed && !controller.isLoading.value
                              ? () {
                                if (buttonText == 'Proceed to Payment') {
                                  showSuccessDialog(context);
                                } else {
                                  HapticFeedback.lightImpact();
                                  debugPrint(
                                    'Button pressed: activeStep=$activeStep, '
                                    'uiStep=$uiStep, canProceed=$canProceed, '
                                    'selectedProducts=${controller.selectedProducts}, '
                                    'isPayment=$isPayment, isAgreement=$isAgreement',
                                  );
                                  controller.submitForm(
                                    isPayment: isPayment,
                                    isAgreement: isAgreement,
                                    context: context,
                                  );
                                }
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
        return ContactDetailsStep(key: const ValueKey('step4'));
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
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final bool isActive = index == currentStep;
        final bool isCompleted = index < currentStep;
        final Color circleColor =
            isCompleted
                ? const Color(0xFF2EC4F3)
                : isActive
                ? const Color(0xFFBFD633)
                : const Color(0xFFEAEEF5);
        final Color textColor =
            isCompleted || isActive
                ? const Color(0xFF0F1C35)
                : const Color(0xFF8E99B7);

        return Expanded(
          child: Row(
            children: [
              if (index > 0)
                Expanded(
                  child: Container(
                    height: 2,
                    color:
                        isCompleted
                            ? const Color(0xFF2EC4F3)
                            : const Color(0xFFEAEEF5),
                  ),
                ),
              Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: circleColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child:
                          isCompleted
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
                                  color:
                                      isActive
                                          ? Colors.white
                                          : const Color(0xFF8E99B7),
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labels[index],
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class EngagementModelStep extends StatelessWidget {
  const EngagementModelStep({Key? key}) : super(key: key);

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
              controller.selectEngagementModel(EngagementModel.saas);
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
              controller.selectEngagementModel(EngagementModel.reseller);
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
              controller.selectEngagementModel(EngagementModel.partner);
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
              controller.selectEngagementModel(EngagementModel.whitelabel);
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
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? color : const Color(0xFFEAEEF5),
          width: isSelected ? 2 : 1,
        ),
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: color.withOpacity(0.12),
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
                    color: color.withOpacity(0.1),
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
  const ProductSelectionStep({Key? key}) : super(key: key);

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
                    color: Colors.white.withOpacity(0.9),
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
                                color: product.color.withOpacity(0.1),
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
                                color: product.color.withOpacity(0.1),
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
  const PlanPricingStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();
    final userRanges = ['1-10', '11-20', '21-30', '31-40', '41-50'];

    return Obx(() {
      final isSaaS = controller.engagementModel.value == EngagementModel.saas;
      final selectedProducts = controller.selectedProducts;
      debugPrint(
        'PlanPricingStep: isSaaS=$isSaaS, selectedProducts=$selectedProducts',
      );

      return Form(
        key: controller.pricingFormKey, // Changed: Use pricingFormKey
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
                  ? 'Specify the number of users for each product and review pricing.'
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
                          Text(
                            'Price: ₹${product.pricePerUser}/user/month',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value:
                                controller.productUserCounts[productName] ==
                                        null
                                    ? userRanges[0]
                                    : userRanges.firstWhere((range) {
                                      final minUsers = int.parse(
                                        range.split('-')[0],
                                      );
                                      final currentCount =
                                          controller
                                              .productUserCounts[productName] ??
                                          1;
                                      return currentCount >= minUsers &&
                                          currentCount <=
                                              int.parse(range.split('-')[1]);
                                    }, orElse: () => userRanges[0]),
                            decoration: InputDecoration(
                              labelText: 'No. of Users',
                              prefixIcon: Icon(
                                Icons.group_outlined,
                                color:
                                    selectedProducts.indexOf(productName) % 2 ==
                                            0
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
                            items:
                                userRanges.map((range) {
                                  return DropdownMenuItem<String>(
                                    value: range,
                                    child: Text(range),
                                  );
                                }).toList(),
                            onChanged: (String? value) {
                              if (value != null) {
                                final minUsers = int.parse(value.split('-')[0]);
                                controller.updateUserCount(
                                  productName,
                                  minUsers.toString(),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          Obx(() {
                            final userCount =
                                controller.productUserCounts[productName] ?? 1;
                            return Text(
                              'Total: ₹${(product.pricePerUser * userCount).toStringAsFixed(2)}/month',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color:
                                    selectedProducts.indexOf(productName) % 2 ==
                                            0
                                        ? const Color(0xFFBFD633)
                                        : const Color(0xFF2EC4F3),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
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
  const ContactDetailsStep({Key? key}) : super(key: key);

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
    Key? key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.companyController,
    required this.phoneController,
    required this.messageController,
    required this.messageLabel,
    required this.messagePlaceholder,
  }) : super(key: key);

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
        decoration: BoxDecoration(
          color: Colors.grey.shade200,

        ),
        child: Container(
          color: Colors.white.withOpacity(0.1),
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
                      color: const Color(0xFFBFD633).withOpacity(0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFBFD633).withOpacity(0.1),
                          blurRadius: 50,
                          offset: const Offset(0, 4),
                        )
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
                  //     color: Colors.white.withOpacity(0.9),
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
