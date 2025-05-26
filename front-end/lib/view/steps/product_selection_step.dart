import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/app_controller.dart';

class ProductSelectionStep extends StatelessWidget {
  const ProductSelectionStep({super.key});

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
                    color: Colors.white.withValues(alpha: 0.9),
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
                        color: product.color.withValues(alpha: 0.1),
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
                                color: product.color.withValues(alpha: 0.1),
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
