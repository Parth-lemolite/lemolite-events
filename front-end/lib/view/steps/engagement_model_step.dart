import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/product_inquiry_controller.dart';
import '../../models/enums.dart';

class EngagementModelStep extends StatelessWidget {
  const EngagementModelStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductInquiryController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Engagement Model',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Choose how you\'d like to engage with our products.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 32),
        Obx(
              () => _buildEngagementOption(
            title: 'SaaS-Based Subscription',
            description: 'Cloud-based subscription with seamless updates',
            icon: Icons.cloud_outlined,
            color: const Color(0xFF2EC4F3),
            isSelected:
            controller.engagementModel.value == EngagementModel.saas,
            onTap: () {
              HapticFeedback.lightImpact();
              controller.selectEngagementModel(EngagementModel.saas);
            },
          ),
        ),
        const SizedBox(height: 16),
        Obx(
              () => _buildEngagementOption(
            title: 'Reseller',
            description: 'Distribute our products under your brand',
            icon: Icons.store_outlined,
            color: const Color(0xFFBFD633),
            isSelected:
            controller.engagementModel.value == EngagementModel.reseller,
            onTap: () {
              HapticFeedback.lightImpact();
              controller.selectEngagementModel(EngagementModel.reseller);
            },
          ),
        ),
        const SizedBox(height: 16),
        Obx(
              () => _buildEngagementOption(
            title: 'Partner',
            description: 'Collaborate to integrate solutions',
            icon: Icons.handshake_outlined,
            color: const Color(0xFF2EC4B6),
            isSelected:
            controller.engagementModel.value == EngagementModel.partner,
            onTap: () {
              HapticFeedback.lightImpact();
              controller.selectEngagementModel(EngagementModel.partner);
            },
          ),
        ),
        const SizedBox(height: 16),
        Obx(
              () => _buildEngagementOption(
            title: 'Whitelabel',
            description: 'Customize and brand our solutions as your own',
            icon: Icons.branding_watermark_outlined,
            color: const Color(0xFF2EC4F3),
            isSelected:
            controller.engagementModel.value == EngagementModel.whitelabel,
            onTap: () {
              HapticFeedback.lightImpact();
              controller.selectEngagementModel(EngagementModel.whitelabel);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEngagementOption({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? color : const Color(0xFFEAEEF5),
          width: isSelected ? 2 : 1,
        ),
        boxShadow:
        isSelected
            ? [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 32, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F1C35),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF404B69),
                        ),
                      ),
                    ],
                  ),
                ),
                Semantics(
                  label: title,
                  child: Radio(
                    value: true,
                    groupValue: isSelected,
                    onChanged: (_) => onTap(),
                    activeColor: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
