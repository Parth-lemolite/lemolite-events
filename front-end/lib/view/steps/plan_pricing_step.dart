import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/product_inquiry_controller.dart';
import '../../models/enums.dart';

class PlanPricingStep extends StatelessWidget {
  const PlanPricingStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductInquiryController>();    // Define the user ranges to match your JSON data
    final userRanges = [
      '1-10',
      '11-20',
      '21-30',
      '31-40',
      '41-50',
      '10-50',
      '51-100',
      '100-200',
      '201-500',
    ];

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
                            // Use the stored range or default to the first option
                            value:
                            controller.productUserRanges[productName] ??
                                userRanges[0],
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
                                // Store the selected range
                                controller.updateUserRange(productName, value);
                                // Update user count based on the range (optional, for totalPrice calculation)
                                final minUsers = int.parse(value.split('-')[0]);
                                controller.updateUserCount(
                                  productName,
                                  minUsers.toString(),
                                );
                              }
                            },
                            validator:
                                (value) =>
                            value == null
                                ? 'Please select a user range'
                                : null,
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
