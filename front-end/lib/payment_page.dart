import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';

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
}
