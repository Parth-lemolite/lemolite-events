import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/app_controller.dart';
import '../../models/enums.dart';
import '../screens/plan_feature_screen.dart';

class PlanPricingStep extends StatelessWidget {
  const PlanPricingStep({super.key});

  // Helper method to get available plans and prices for a product
  Map<String, dynamic> getProductPlansAndPrices(String productName) {
    productName = productName.toLowerCase().trim();

    if (productName.contains('integrated') ||
        productName.contains('s2h + nexstaff')) {
      return {
        'plans': ['SaaS Based', 'One Time Cost'],
        'prices': {
          'SaaS Based': 89.0, // $ per user per month
          'One Time Cost': 56500.0, // $ one time payment
        },
      };
    }

    if (productName.contains('scan2hire') || productName.contains('s2h')) {
      return {
        'plans': ['Freemium', 'Enterprise'],
        'prices': {
          'Freemium': 0.0,
          'Enterprise': 79.0, // $ per user per month
        },
      };
    }

    if (productName.contains('nexstaff')) {
      return {
        'plans': ['Freemium', 'Enterprise'],
        'prices': {
          'Freemium': 0.0,
          'Enterprise': 69.0, // $ per user per month
        },
      };
    }

    if (productName == 'crm') {
      return {
        'plans': ['Growth', 'Enterprise'],
        'prices': {
          'Growth': 19.0, // $ per user per month
          'Enterprise': 29.0, // $ per user per month
        },
      };
    }

    if (productName == 'ims') {
      return {
        'plans': ['Enterprise'],
        'prices': {
          'Enterprise': 19.0, // $ per user per month
        },
      };
    }

    // Default return for unknown products
    return {
      'plans': ['Freemium'],
      'prices': {'Freemium': 0.0},
    };
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

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
                final plansAndPrices = getProductPlansAndPrices(productName);
                final availablePlans = plansAndPrices['plans'] as List<String>;

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
                          Obx(() {
                            // Set default plan based on product
                            String defaultPlan;
                            if (productName.toLowerCase().contains(
                              'integrated',
                            ) ||
                                productName.toLowerCase().contains(
                                  's2h + nexstaff',
                                )) {
                              defaultPlan = 'SaaS Based';
                            } else if (productName.toLowerCase() == 'ims') {
                              defaultPlan = 'Enterprise';
                            } else if (productName.toLowerCase() == 'crm') {
                              defaultPlan = 'Growth';
                            } else if (productName.toLowerCase().contains(
                              'scan2hire',
                            ) ||
                                productName.toLowerCase().contains('s2h')) {
                              defaultPlan = 'Freemium';
                            } else if (productName.toLowerCase().contains(
                              'nexstaff',
                            )) {
                              defaultPlan = 'Freemium';
                            } else {
                              defaultPlan = 'Freemium';
                            }

                            final selectedPlan =
                                controller.productPlans[productName] ??
                                    defaultPlan;

                            return DropdownButtonFormField<String>(
                              dropdownColor: Colors.white,
                              value: selectedPlan,
                              decoration: InputDecoration(
                                labelText: 'Plan',
                                prefixIcon: Icon(
                                  Icons.card_membership_outlined,
                                  color:
                                  selectedProducts.indexOf(productName) %
                                      2 ==
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
                              availablePlans.map((plan) {
                                return DropdownMenuItem<String>(
                                  value: plan,
                                  child: Text(plan),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  controller.updatePlan(productName, value);
                                  debugPrint(
                                    'Selected plan for $productName: $value',
                                  );
                                }
                              },
                              validator:
                                  (value) =>
                              value == null
                                  ? 'Please select a plan'
                                  : null,
                            );
                          }),
                          const SizedBox(height: 16),
                          Obx(() {
                            final selectedPlan =
                                controller.productPlans[productName] ?? 'Free';
                            if (selectedPlan != 'Free' &&
                                !selectedPlan.contains('One Time')) {
                              return TextFormField(
                                controller:
                                controller
                                    .userCountControllers[productName],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'No. of Users',
                                  prefixIcon: Icon(
                                    Icons.group_outlined,
                                    color:
                                    selectedProducts.indexOf(productName) %
                                        2 ==
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the number of users';
                                  }
                                  final count = int.tryParse(value);
                                  if (count == null || count <= 0) {
                                    return 'Please enter a valid number';
                                  }
                                  if (count > 99999) {
                                    return 'Number of users cannot exceed 99999';
                                  }
                                  // Add specific validation for Enterprise plans
                                  if (selectedPlan == 'Enterprise' &&
                                      count < 1) {
                                    return 'Enterprise plan requires 1+ users';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  controller.updateUserCount(
                                    productName,
                                    value,
                                  );
                                  debugPrint(
                                    'Updated user count for $productName: $value',
                                  );
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                          const SizedBox(height: 16),
                          Obx(() {
                            final selectedPlan =
                                controller.productPlans[productName] ?? 'Free';
                            final userCount =
                            selectedPlan == 'Free' ||
                                selectedPlan.contains('One Time')
                                ? 1
                                : controller
                                .productUserCounts[productName] ??
                                1;

                            // Get price per user for the selected plan
                            final pricePerUser =
                            (plansAndPrices['prices']?[selectedPlan] ?? 0.0)
                            as double;
                            final price =
                            selectedPlan.contains('One Time')
                                ? pricePerUser
                                : pricePerUser * userCount;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (selectedPlan != 'Free' &&
                                    !selectedPlan.contains('One Time'))
                                  Text(
                                    '\$${pricePerUser.toStringAsFixed(2)} /User /Month',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  selectedPlan.contains('One Time')
                                      ? 'Total: \$${price.toStringAsFixed(2)} (One-time payment)'
                                      : 'Total: \$${price.toStringAsFixed(2)} /Month',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color:
                                    selectedProducts.indexOf(productName) %
                                        2 ==
                                        0
                                        ? const Color(0xFFBFD633)
                                        : const Color(0xFF2EC4F3),
                                  ),
                                ),
                              ],
                            );
                          }),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Get.to(
                                      () => EnhancedPricingScreen(
                                    plan1Name: productName,
                                    plan2Name: productName,
                                  ),
                                );
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
                      Obx(() {
                        double total = 0.0;
                        for (var productName in selectedProducts) {
                          final selectedPlan =
                              controller.productPlans[productName] ?? 'Free';
                          final userCount =
                          selectedPlan == 'Free'
                              ? 1
                              : controller.productUserCounts[productName] ??
                              1;
                          final plansAndPrices = getProductPlansAndPrices(
                            productName,
                          );
                          final pricePerUser =
                          (plansAndPrices['prices']?[selectedPlan] ?? 0.0)
                          as double;
                          total += pricePerUser * userCount;
                        }
                        controller.totalPrice.value = total;
                        return Text(
                          '\$${total.toStringAsFixed(2)} /Month',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2EC4F3),
                          ),
                        );
                      }),
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
