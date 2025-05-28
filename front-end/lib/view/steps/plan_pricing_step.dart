import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/app_controller.dart';
import '../../models/enums.dart';
import '../../models/product_info.dart';
import '../screens/plan_feature_screen.dart';

class PlanPricingStep extends StatelessWidget {
  const PlanPricingStep({super.key});

  Map<String, dynamic> getProductPlansAndPrices(String productName) {
    productName = productName.toLowerCase().trim();

    if (productName.contains('integrated') || productName.contains('s2h + nexstaff')) {
      return {
        'plans': ['SaaS Based', 'One Time Cost'],
        'prices': {
          'SaaS Based': 89.0,
          'One Time Cost': 56500.0,
        },
      };
    }

    if (productName.contains('scan2hire') || productName.contains('s2h')) {
      return {
        'plans': ['Free', 'Premium', 'Enterprise'],
        'prices': {
          'Free': 0.0,
          'Premium': 49.0,
          'Enterprise': 79.0,
        },
      };
    }

    if (productName.contains('nexstaff')) {
      return {
        'plans': ['Free', 'Growth', 'Premium'],
        'prices': {
          'Free': 0.0,
          'Growth': 39.0,
          'Premium': 69.0,
        },
      };
    }

    if (productName == 'crm') {
      return {
        'plans': ['Growth', 'Enterprise'],
        'prices': {
          'Growth': 19.0,
          'Enterprise': 29.0,
        },
      };
    }

    if (productName == 'ims') {
      return {
        'plans': ['Enterprise'],
        'prices': {
          'Enterprise': 19.0,
        },
      };
    }

    return {
      'plans': ['Free'],
      'prices': {'Free': 0.0},
    };
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    // Schedule default plan initialization after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedProducts = controller.selectedProducts;
      for (var productName in selectedProducts) {
        if (controller.productPlans[productName] == null) {
          final plansAndPrices = getProductPlansAndPrices(productName);
          final availablePlans = plansAndPrices['plans'] as List<String>;
          if (availablePlans.isNotEmpty) {
            controller.updatePlan(productName, availablePlans.first);
            debugPrint('Set default plan for $productName: ${availablePlans.first}');
          }
        }
      }
    });

    return Obx(() {
      final isSaaS = controller.engagementModel.value == EngagementModel.saas;
      final selectedProducts = controller.selectedProducts;
      debugPrint('PlanPricingStep: isSaaS=$isSaaS, selectedProducts=$selectedProducts');

      if (!isSaaS || selectedProducts.isEmpty) {
        return const SizedBox.shrink();
      }

      return Form(
        key: controller.pricingFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan & Pricing',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Select a plan and specify the number of users for each product.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ...selectedProducts.map((productName) {
              final product = controller.productsList.firstWhere(
                    (p) => p.name == productName,
                orElse: () => ProductInfo(
                  name: productName,
                  description: '',
                  icon: Icons.extension,
                  color: Colors.grey,
                  pricePerUser: 0.0,
                  userCount: controller.productUserCounts[productName].toString(),
                ),
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
                          final selectedPlan = controller.productPlans[productName] ?? availablePlans.first;

                          return DropdownButtonFormField<String>(
                            dropdownColor: Colors.white,
                            value: selectedPlan,
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
                            items: availablePlans.map((plan) {
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
                          );
                        }),
                        const SizedBox(height: 16),
                        Obx(() {
                          final selectedPlan = controller.productPlans[productName] ?? availablePlans.first;
                          if (selectedPlan != 'Free' && !selectedPlan.contains('One Time')) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Number of Users',
                                    prefixIcon: Icon(
                                      Icons.people_outline,
                                      color: selectedProducts.indexOf(productName) % 2 == 0
                                          ? const Color(0xFFBFD633)
                                          : const Color(0xFF2EC4F3),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(5),
                                  ],
                                  initialValue: (controller.productUserCounts[productName] ?? 1).toString(),
                                  onChanged: (value) {
                                    if (value.isEmpty) return;
                                    final count = int.tryParse(value) ?? 1;
                                    if (count > 99999) return;
                                    controller.updateUserCount(productName, count.toString());
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter number of users';
                                    }
                                    final count = int.tryParse(value);
                                    if (count == null || count < 1) {
                                      return 'Please enter a valid number';
                                    }
                                    if (count > 99999) {
                                      return 'Maximum 99999 users allowed';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          }
                          return const SizedBox(height: 16);
                        }),
                        Obx(() {
                          final selectedPlan = controller.productPlans[productName] ?? availablePlans.first;
                          final userCount = selectedPlan == 'Free' || selectedPlan.contains('One Time')
                              ? 1
                              : controller.productUserCounts[productName] ?? 1;

                          final pricePerUser = (plansAndPrices['prices']?[selectedPlan] ?? 0.0) as double;
                          final price = selectedPlan.contains('One Time')
                              ? pricePerUser
                              : pricePerUser * userCount;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (selectedPlan != 'Free' && !selectedPlan.contains('One Time'))
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
                                    : selectedPlan == 'Free'
                                    ? 'Free'
                                    : 'Total: \$${price.toStringAsFixed(2)} /Month',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: selectedProducts.indexOf(productName) % 2 == 0
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
                              Get.to(() => EnhancedPricingScreen(
                                plan1Name: productName,
                                plan2Name: productName,
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
                    Obx(() {
                      double total = 0.0;
                      for (var productName in selectedProducts) {
                        final selectedPlan = controller.productPlans[productName] ?? getProductPlansAndPrices(productName)['plans'].first;
                        final userCount = selectedPlan == 'Free' || selectedPlan.contains('One Time')
                            ? 1
                            : controller.productUserCounts[productName] ?? 1;
                        final plansAndPrices = getProductPlansAndPrices(productName);
                        final pricePerUser = (plansAndPrices['prices']?[selectedPlan] ?? 0.0) as double;
                        final productTotal = selectedPlan.contains('One Time')
                            ? pricePerUser
                            : pricePerUser * userCount;
                        total += productTotal;
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
          ],
        ),
      );
    });
  }
}