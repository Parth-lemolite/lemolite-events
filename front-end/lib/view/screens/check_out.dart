import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';

class CheckoutStep extends StatelessWidget {
  const CheckoutStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    return Obx(() {
      final selectedProducts = controller.selectedProducts;
      final isSaaS = controller.engagementModel.value == EngagementModel.saas;
      final hasCards = controller.savedCards.isNotEmpty;

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Checkout',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Review your order and add a payment method.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            // Order Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F1C35),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...selectedProducts.map((productName) {
                      final product = controller.productsList.firstWhere(
                            (p) => p.name == productName,
                      );
                      final userCount = controller.productUserCounts[productName] ?? 1;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '$productName ($userCount users)',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              '₹${(product.pricePerUser * userCount).toStringAsFixed(2)}/mo',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      );
                    }),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F1C35),
                          ),
                        ),
                        Text(
                          '₹${controller.totalPrice.toStringAsFixed(2)}/mo',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2EC4F3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Payment Methods
            Text(
              'Payment Methods',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saved Cards',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F1C35),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      final savedCards = controller.savedCards;
                      if (savedCards.isEmpty) {
                        return Text(
                          'No cards added yet.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        );
                      }
                      return Column(
                        children: savedCards.asMap().entries.map((entry) {
                          final index = entry.key;
                          final card = entry.value;
                          return CardItem(
                            cardNumber: card['cardNumber']!,
                            expiryDate: card['expiryDate']!,
                            cardHolder: card['cardHolder']!,
                            onRemove: () {
                              controller.removeCard(index);
                            },
                          );
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: 16),
                    GradientButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _showAddCardDialog(context, controller);
                      },
                      isLoading: false,
                      text: 'Add New Card',
                      gradientColors: const [
                        Color(0xFFBFD633),
                        Color(0xFF2EC4F3),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }

  void _showAddCardDialog(BuildContext context, AppController controller) {
    final cardNumberController = TextEditingController();
    final expiryDateController = TextEditingController();
    final cardHolderController = TextEditingController();
    final cvvController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          title: Text(
            'Add New Card',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F1C35),
            ),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: cardNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Card Number',
                      hintText: '1234 5678 9012 3456',
                      prefixIcon: Icon(Icons.credit_card),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter card number';
                      }
                      if (!RegExp(r'^\d{16}$').hasMatch(value.replaceAll(' ', ''))) {
                        return 'Enter a valid 16-digit card number';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                      CardNumberInputFormatter(),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: expiryDateController,
                          keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                            labelText: 'Expiry Date',
                            hintText: 'MM/YY',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter expiry date';
                            }
                            if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value)) {
                              return 'Enter valid MM/YY';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                            LengthLimitingTextInputFormatter(5),
                            ExpiryDateInputFormatter(),
                          ],
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: cvvController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'CVV',
                            hintText: '123',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter CVV';
                            }
                            if (!RegExp(r'^\d{3,4}$').hasMatch(value)) {
                              return 'Enter valid CVV';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: cardHolderController,
                    decoration: const InputDecoration(
                      labelText: 'Cardholder Name',
                      hintText: 'Enter cardholder name',
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter cardholder name' : null,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade700,
                ),
              ),
            ),
            GradientButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  controller.addCard({
                    'cardNumber': '**** **** **** ${cardNumberController.text.substring(12)}',
                    'expiryDate': expiryDateController.text,
                    'cardHolder': cardHolderController.text,
                  });
                  Navigator.pop(context);
                  Get.snackbar(
                    'Success',
                    'Card added successfully',
                    backgroundColor: Colors.green.shade50,
                    colorText: Colors.green.shade900,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 10,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              isLoading: false,
              text: 'Add Card',
              gradientColors: const [
                Color(0xFFBFD633),
                Color(0xFF2EC4F3),
              ],
            ),
          ],
        );
      },
    );
  }
}

class CardItem extends StatelessWidget {
  final String cardNumber;
  final String expiryDate;
  final String cardHolder;
  final VoidCallback onRemove;

  const CardItem({
    super.key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolder,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF2EC4F3).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.credit_card,
                color: Color(0xFF2EC4F3),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardNumber,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF0F1C35),
                    ),
                  ),
                  Text(
                    'Expires: $expiryDate',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF404B69),
                    ),
                  ),
                  Text(
                    cardHolder,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF404B69),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(' ', '');
    if (newText.length > 16) {
      newText = newText.substring(0, 16);
    }
    String formatted = '';
    for (int i = 0; i < newText.length; i++) {
      formatted += newText[i];
      if ((i + 1) % 4 == 0 && i + 1 < newText.length) {
        formatted += ' ';
      }
    }
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll('/', '');
    if (newText.length > 4) {
      newText = newText.substring(0, 4);
    }
    String formatted = '';
    if (newText.length > 2) {
      formatted = '${newText.substring(0, 2)}/${newText.substring(2)}';
    } else {
      formatted = newText;
    }
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}