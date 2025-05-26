import 'package:flutter/material.dart';
import '../widgets/payment_button.dart';

class PaymentExampleScreen extends StatelessWidget {
  const PaymentExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Your session ID from the API
    const String sessionId =
        'session_iW-5z_rq3y-9nLlgL9pFWEcUqqKsyMGq0Ko3P_osY1jPXDEpxK7KEFN4OJiFBm1PYLXKVBstS41Ij5sQQ_vrO7lPRsL5k9JCIe5WIWWwF5tAPUwwNAXV9Jc2O4VbdQpaymentpayment';

    return Scaffold(
      appBar: AppBar(title: const Text('Payment Example')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Complete Your Payment',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Secure payment powered by Cashfree',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Amount:'), Text('₹1000.00')],
                      ),
                      const Divider(),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '₹1000.00',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: PaymentButton(
                          sessionId: sessionId,
                          amount: 1000.00,
                          buttonText: 'Pay Securely',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
