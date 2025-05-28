import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:lemolite_events/service/payment_service.dart';
import 'package:lemolite_events/view/screens/payment_failure_screen.dart';
import 'package:lemolite_events/view/screens/payment_success_screen.dart';

class PaymentResponse {
  final bool success;
  final PaymentData data;
  final String paymentLink;
  final String paymentSessionId;
  final String message;

  PaymentResponse({
    required this.success,
    required this.data,
    required this.paymentLink,
    required this.paymentSessionId,
    required this.message,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      success: json['success'],
      data: PaymentData.fromJson(json['data']),
      paymentLink: json['paymentLink'],
      paymentSessionId: json['paymentSessionId'],
      message: json['message'],
    );
  }
}

class PaymentData {
  final String orderId;
  final double amount;
  final String status;

  PaymentData({
    required this.orderId,
    required this.amount,
    required this.status,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      orderId: json['payment']['orderId'],
      amount: json['payment']['amount'].toDouble(),
      status: json['payment']['status'],
    );
  }
}

class PaymentPage extends StatefulWidget {
  final PaymentResponse paymentResponse;

  const PaymentPage({Key? key, required this.paymentResponse})
      : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    super.initState();
    CFPaymentGatewayService().setCallback(onVerify, onError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${widget.paymentResponse.data.orderId}'),
            Text('Amount: ₹${widget.paymentResponse.data.amount}'),
            Text('Status: ${widget.paymentResponse.data.status}'),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => initiatePayment(),
                child: const Text('Proceed to Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CFSession? createSession() {
    try {
      var session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.SANDBOX)
          .setOrderId(widget.paymentResponse.data.orderId)
          .setPaymentSessionId(widget.paymentResponse.paymentSessionId)
          .build();
      return session;
    } on CFException catch (e) {
      print('Session creation error: ${e.message}');
    }
    return null;
  }

  void initiatePayment() async {
    try {
      var session = createSession();
      if (session != null) {
        var cfWebCheckout = CFWebCheckoutPaymentBuilder().setSession(session);
        await CFPaymentGatewayService().doPayment(cfWebCheckout.build());
      } else {
        // Show error to user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create payment session')),
        );
      }
    } on CFException catch (e) {
      print('Payment initiation error: ${e.message}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  void onVerify(String orderId) {
    // Handle successful payment verification
    print('Payment verified for order: $orderId');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment successful for order: $orderId')),
    );
    // Here you can navigate to a success page or update your UI accordingly
  }

  void onError(CFErrorResponse errorResponse, String orderId) {
    // Handle payment error
    print('Payment error for order: $orderId');
    print('Error: ${errorResponse.getMessage()}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${errorResponse.getMessage()}')),
    );
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

      // final currentProducts = [...selectedProducts];
      // final currentEngagementModel = engagementModel.value;
      // final currentPlans = Map<String, String>.from(productPlans);
      // final currentUserCounts = Map<String, int>.from(productUserCounts);

      // selectedProducts.clear();
      // engagementModel.value = null;
      // productPlans.clear();
      // productUserCounts.clear();
      // activeStep.value = 0;

      if (success && paymentStatus == 'completed') {
        if (kIsWeb) {
          // For web platform
          await Get.to(
            () => PaymentSuccessScreen(orderId: orderId),
            preventDuplicates: false,
          );
        } else {
          // For mobile platforms
          await Get.offAll(
            () => PaymentSuccessScreen(orderId: orderId),
            predicate: (route) => false,
          );
        }

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
        if (kIsWeb) {
          // For web platform
          await Get.to(
            () => PaymentFailureScreen(
              orderId: orderId,
              message: message,
            ),
            preventDuplicates: false,
          );
        } else {
          // For mobile platforms
          await Get.offAll(
            () => PaymentFailureScreen(
              orderId: orderId,
              message: message,
            ),
            predicate: (route) => false,
          );
        }

        Get.snackbar(
          'Failed',
          message,
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          margin: const EdgeInsets.all(16),
          borderRadius: 10,
          snackPosition: SnackPosition.BOTTOM,
        );

        // selectedProducts.addAll(currentProducts);
        // engagementModel.value = currentEngagementModel;
        // productPlans.addAll(currentPlans);
        // productUserCounts.addAll(currentUserCounts);
      }

      Future.delayed(const Duration(milliseconds: 300), () {
        if (success && paymentStatus == 'completed') {}
      });
    } catch (e) {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print("Payment verification error: $e");
      }

      if (kIsWeb) {
        // For web platform
        await Get.to(
          () => PaymentFailureScreen(
            orderId: orderId,
            message:
                'An error occurred while verifying the payment. Please contact support.',
          ),
          preventDuplicates: false,
        );
      } else {
        // For mobile platforms
        await Get.offAll(
          () => PaymentFailureScreen(
            orderId: orderId,
            message:
                'An error occurred while verifying the payment. Please contact support.',
          ),
          predicate: (route) => false,
        );
      }

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
}

class PaymentController extends GetxController {
  final selectedProducts = <dynamic>[].obs;
  final engagementModel = Rxn<dynamic>();
  final productPlans = <String, String>{}.obs;
  final productUserCounts = <String, int>{}.obs;
  final activeStep = 0.obs;

  // Payment Service
  // final PaymentService = Get.find<PaymentService>();

  void resetFlow() {
    selectedProducts.clear();
    engagementModel.value = null;
    productPlans.clear();
    productUserCounts.clear();
    activeStep.value = 0;
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
        (orderId) => PaymentService.verifyPayment(orderId),
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
}
