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

    if (productName.contains('integrated') ||
        productName.contains('s2h + nexstaff')) {
      return {
        'plans': ['SaaS Based', 'One Time Cost'],
        'prices': {
          'SaaS Based': 89.0,
          'One Time Cost': 52000.0,
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

  // Get user count constraints for each plan
  Map<String, int> getUserCountConstraints(String productName, String plan) {
    productName = productName.toLowerCase().trim();

    if (productName.contains('nexstaff')) {
      switch (plan) {
        case 'Free':
          return {'min': 1, 'max': 1};
        case 'Growth':
          return {'min': 5, 'max': 20};
        case 'Premium':
          return {'min': 21, 'max': 99999};
        case 'SaaS Based':
          return {'min': 1, 'max': 99999};
        default:
          return {'min': 1, 'max': 99999};
      }
    } else {
      // For non-Nexstaff products
      switch (plan) {
        case 'Free':
          return {'min': 1, 'max': 1};
        case 'Premium':
        case 'Growth':
          return {'min': 5, 'max': 20};
        case 'Enterprise':
          return {'min': 21, 'max': 99999};
        case 'SaaS Based':
          return {'min': 1, 'max': 99999};
        default:
          return {'min': 1, 'max': 99999};
      }
    }
  }

  // Validate and correct user count
  int validateAndCorrectUserCount(
      String productName, String plan, int enteredCount) {
    final constraints = getUserCountConstraints(productName, plan);
    final minUsers = constraints['min']!;
    final maxUsers = constraints['max']!;

    if (enteredCount < minUsers) {
      return minUsers;
    } else if (enteredCount > maxUsers) {
      return maxUsers;
    }
    return enteredCount;
  }

  String getValidationMessage(
      String productName, String plan, int enteredCount) {
    final constraints = getUserCountConstraints(productName, plan);
    final minUsers = constraints['min']!;
    final maxUsers = constraints['max']!;

    if (enteredCount < minUsers) {
      return 'Minimum $minUsers users required for $plan plan.';
    } else if (enteredCount > maxUsers) {
      if (maxUsers == 99999) {
        return 'Maximum 5 digits allowed for $plan plan.';
      } else {
        return 'Maximum $maxUsers users allowed for $plan plan.';
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    // Initialize plans and user counts after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePlansAndUserCounts(controller);
    });

    return Obx(() {
      final isSaaS = controller.engagementModel.value == EngagementModel.saas;
      final selectedProducts = controller.selectedProducts;

      if (!isSaaS || selectedProducts.isEmpty) {
        return const SizedBox.shrink();
      }

      return Form(
        key: controller.pricingFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Plan & Pricing',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Select a plan and specify the number of users for each product.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ...selectedProducts.map((productName) {
              return _buildProductCard(context, controller, productName);
            }).toList(),
            const SizedBox(height: 16),
            _buildGrandTotalCard(controller, selectedProducts),
          ],
        ),
      );
    });
  }

  void _initializePlansAndUserCounts(AppController controller) {
    for (var productName in controller.selectedProducts) {
      if (controller.productPlans[productName] == null) {
        final plansAndPrices = getProductPlansAndPrices(productName);
        final availablePlans = plansAndPrices['plans'] as List<String>;
        if (availablePlans.isNotEmpty) {
          final defaultPlan = availablePlans.first;
          controller.updatePlan(productName, defaultPlan);

          final constraints = getUserCountConstraints(productName, defaultPlan);
          final defaultUserCount = constraints['min'].toString();

          controller.updateUserCount(productName, defaultUserCount);
          controller.userCountControllers[productName] ??=
              TextEditingController(text: defaultUserCount);
        }
      }
    }
  }

  Widget _buildProductCard(
      BuildContext context, AppController controller, String productName) {
    final product = controller.productsList.firstWhere(
      (p) => p.name == productName,
      orElse: () => ProductInfo(
        name: productName,
        description: '',
        icon: Icons.extension,
        color: Colors.grey,
        pricePerUser: 0.0,
        userCount: '1',
      ),
    );

    final plansAndPrices = getProductPlansAndPrices(productName);
    final availablePlans = plansAndPrices['plans'] as List<String>;

    controller.userCountControllers[productName] ??= TextEditingController(
      text: controller.productUserCounts[productName]?.toString() ?? '1',
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F1C35),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      controller.toggleProduct(product.name);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.red.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Remove',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildPlanDropdown(controller, productName, availablePlans),
              const SizedBox(height: 16),
              _buildUserCountField(context, controller, productName),
              _buildPriceDisplay(controller, productName, plansAndPrices),
              const SizedBox(height: 16),
              _buildSeeFeatures(productName),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanDropdown(AppController controller, String productName,
      List<String> availablePlans) {
    return Obx(() {
      final selectedPlan =
          controller.productPlans[productName] ?? availablePlans.first;

      return Theme(
        data: ThemeData(
          canvasColor: Colors.white
        ),
        child: DropdownButtonFormField<String>(
          value: selectedPlan,
          decoration: InputDecoration(
            labelText: 'Plan',
            prefixIcon: Icon(
              Icons.card_membership_outlined,
              color: controller.selectedProducts.indexOf(productName) % 2 == 0
                  ? const Color(0xFFBFD633)
                  : const Color(0xFF2EC4F3),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: availablePlans
              .map((plan) => DropdownMenuItem(value: plan, child: Text(plan)))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              _handlePlanChange(controller, productName, value);
            }
          },
        ),
      );
    });
  }

  void _handlePlanChange(
      AppController controller, String productName, String newPlan) {
    // Update plan first
    controller.updatePlan(productName, newPlan);

    // Get constraints for new plan
    final constraints = getUserCountConstraints(productName, newPlan);
    final minUsers = constraints['min']!;

    // Get current user count
    final currentUserCount = int.tryParse(
            controller.userCountControllers[productName]?.text ?? '1') ??
        1;

    // Validate and correct user count
    final correctedUserCount =
        validateAndCorrectUserCount(productName, newPlan, currentUserCount);

    // Update controller and text field
    controller.userCountControllers[productName]?.text =
        correctedUserCount.toString();
    controller.updateUserCount(productName, correctedUserCount.toString());

    // Force UI update
    controller.update();
  }

  Widget _buildUserCountField(
      BuildContext context, AppController controller, String productName) {
    return Obx(() {
      final selectedPlan = controller.productPlans[productName] ?? '';

      if (selectedPlan == 'Free' || selectedPlan.contains('One Time')) {
        return const SizedBox.shrink();
      }

      final constraints = getUserCountConstraints(productName, selectedPlan);
      final minUsers = constraints['min']!;
      final maxUsers = constraints['max']!;

      // Initialize focus node if not exists
      controller.focusNodes[productName] ??= FocusNode();

      // Add focus listener only once
      if (!controller.focusNodes[productName]!.hasListeners) {
        controller.focusNodes[productName]!.addListener(() {
          if (!controller.focusNodes[productName]!.hasFocus) {
            _handleUserCountFocusLost(context, controller, productName);
          }
        });
      }

      return TextFormField(
        controller: controller.userCountControllers[productName],
        focusNode: controller.focusNodes[productName],
        decoration: InputDecoration(
          labelText: 'Number of Users',
          hintText:
              _getUserCountHint(productName, selectedPlan, minUsers, maxUsers),
          prefixIcon: Icon(
            Icons.people_outline,
            color: controller.selectedProducts.indexOf(productName) % 2 == 0
                ? const Color(0xFFBFD633)
                : const Color(0xFF2EC4F3),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(5),
        ],
        validator: (value) =>
            _validateUserCount(productName, selectedPlan, value),
      );
    });
  }

  String _getUserCountHint(
      String productName, String selectedPlan, int minUsers, int maxUsers) {
    if (maxUsers == 99999) {
      return '$minUsers-99999 users';
    } else {
      return '$minUsers-$maxUsers users';
    }
  }

  void _handleUserCountFocusLost(
      BuildContext context, AppController controller, String productName) {
    final selectedPlan = controller.productPlans[productName] ?? '';
    final enteredText =
        controller.userCountControllers[productName]?.text ?? '1';
    final enteredCount = int.tryParse(enteredText) ?? 1;

    final correctedCount =
        validateAndCorrectUserCount(productName, selectedPlan, enteredCount);
    final validationMessage =
        getValidationMessage(productName, selectedPlan, enteredCount);

    if (correctedCount != enteredCount) {
      // Update the text field and controller
      controller.userCountControllers[productName]?.text =
          correctedCount.toString();
      controller.updateUserCount(productName, correctedCount.toString());

      // Show warning message
      if (validationMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(validationMessage),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else {
      // Just update the controller
      controller.updateUserCount(productName, enteredCount.toString());
    }
  }

  String? _validateUserCount(
      String productName, String selectedPlan, String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter number of users';
    }

    final count = int.tryParse(value);
    if (count == null) {
      return 'Please enter a valid number';
    }

    final constraints = getUserCountConstraints(productName, selectedPlan);
    final minUsers = constraints['min']!;
    final maxUsers = constraints['max']!;

    if (count < minUsers || count > maxUsers) {
      if (maxUsers == 99999) {
        return 'Allowed range: $minUsers to 99999 users for $selectedPlan plan';
      } else {
        return 'Allowed range: $minUsers to $maxUsers users for $selectedPlan plan';
      }
    }

    return null;
  }

  Widget _buildPriceDisplay(AppController controller, String productName,
      Map<String, dynamic> plansAndPrices) {
    return Obx(() {
      final selectedPlan = controller.productPlans[productName] ?? '';
      final userCount = selectedPlan == 'Free' ||
              selectedPlan.contains('One Time')
          ? 1
          : int.tryParse(
                  controller.userCountControllers[productName]?.text ?? '1') ??
              1;

      final pricePerUser =
          (plansAndPrices['prices']?[selectedPlan] ?? 0.0) as double;
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
                  fontSize: 14, color: const Color(0xFF64748B)),
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
              color: controller.selectedProducts.indexOf(productName) % 2 == 0
                  ? const Color(0xFFBFD633)
                  : const Color(0xFF2EC4F3),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSeeFeatures(String productName) {
    return Align(
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
          ),
        ),
      ),
    );
  }

  Widget _buildGrandTotalCard(
      AppController controller, List<String> selectedProducts) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                  double grandTotal = 0;
                  double monthlyTotal = 0;
                  double oneTimeTotal = 0;

                  for (var productName in selectedProducts) {
                    final plansAndPrices =
                        getProductPlansAndPrices(productName);
                    final selectedPlan =
                        controller.productPlans[productName] ?? '';
                    final pricePerUser =
                        (plansAndPrices['prices']?[selectedPlan] ?? 0.0)
                            as double;

                    final userCount = selectedPlan == 'Free' ||
                            selectedPlan.contains('One Time')
                        ? 1
                        : int.tryParse(controller
                                    .userCountControllers[productName]?.text ??
                                '1') ??
                            1;

                    final totalPriceForProduct =
                        selectedPlan.contains('One Time')
                            ? pricePerUser
                            : pricePerUser * userCount;

                    // Check if plan should be excluded from 3-month calculation
                    if (selectedPlan == 'Free' ||
                        selectedPlan.contains('One Time')) {
                      // Add directly without 3-month multiplication
                      grandTotal += totalPriceForProduct;
                      if (selectedPlan.contains('One Time')) {
                        oneTimeTotal += totalPriceForProduct;
                      }
                    } else {
                      // Apply 3-month minimum contract period (includes SaaS Based)
                      final threeMonthPrice = totalPriceForProduct * 3;
                      grandTotal += threeMonthPrice;
                      monthlyTotal += totalPriceForProduct;
                    }
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (monthlyTotal > 0)
                        Text(
                          'Monthly: \$${monthlyTotal.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      if (oneTimeTotal > 0)
                        Text(
                          'One-time: \$${oneTimeTotal.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      Text(
                        '\$${grandTotal.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F1C35),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '*Minimum 3-month contract period applies to Premium, Growth, Enterprise, and SaaS Based plans',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: const Color(0xFF64748B),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
