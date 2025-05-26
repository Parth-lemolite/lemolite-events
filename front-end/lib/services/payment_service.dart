import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class PaymentService {
  static void initializePayment(String sessionId) {
    final String paymentUrl =
        'https://payments.cashfree.com/order/#$sessionId';
    Get.to(() => PaymentScreen(paymentUrl: paymentUrl));
  }
}

class PaymentScreen extends StatelessWidget {
  final String paymentUrl;

  const PaymentScreen({super.key, required this.paymentUrl});

  @override
  Widget build(BuildContext context) {
    late final WebViewController controller;

    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
                // Handle success and failure URLs here
                if (request.url.contains('success')) {
                  Get.back(result: 'success');
                  return NavigationDecision.prevent;
                } else if (request.url.contains('failure')) {
                  Get.back(result: 'failure');
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(paymentUrl));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
