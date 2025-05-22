import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PlanFeaturesScreen extends StatelessWidget {
  final String productName;

  const PlanFeaturesScreen({super.key, required this.productName});

  // Define features for each plan
  Map<String, List<Map<String, dynamic>>> getPlanFeatures() {
    return {
      'Free': [
        {
          'icon': Icons.account_circle,
          'title': 'Basic User Profile',
          'description':
          'Create and manage your basic user profile with essential information.',
        },
        {
          'icon': Icons.storage,
          'title': '1GB Storage',
          'description':
          'Get 1GB of cloud storage for your files and documents.',
        },
        {
          'icon': Icons.email,
          'title': 'Email Support',
          'description':
          'Access to community support via email with standard response time.',
        },
        {
          'icon': Icons.mobile_friendly,
          'title': 'Mobile App Access',
          'description':
          'Use our mobile application on iOS and Android devices.',
        },
        {
          'icon': Icons.security,
          'title': 'Basic Security',
          'description':
          'Standard encryption and security measures for your data.',
        },
      ],
      'Essential': [
        {
          'icon': Icons.account_circle,
          'title': 'Enhanced User Profile',
          'description':
          'Advanced profile customization with additional fields and preferences.',
        },
        {
          'icon': Icons.storage,
          'title': '50GB Storage',
          'description':
          'Expanded storage capacity of 50GB for all your files and projects.',
        },
        {
          'icon': Icons.support_agent,
          'title': 'Priority Support',
          'description':
          '24/7 priority customer support with faster response times.',
        },
        {
          'icon': Icons.analytics,
          'title': 'Advanced Analytics',
          'description':
          'Detailed analytics and insights about your usage and performance.',
        },
        {
          'icon': Icons.group,
          'title': 'Team Collaboration',
          'description': 'Collaborate with up to 10 team members on projects.',
        },
        {
          'icon': Icons.backup,
          'title': 'Automated Backups',
          'description':
          'Automatic daily backups of your data and configurations.',
        },
        {
          'icon': Icons.integration_instructions,
          'title': 'API Access',
          'description':
          'Access to REST API for custom integrations and workflows.',
        },
        {
          'icon': Icons.notification_important,
          'title': 'Custom Notifications',
          'description':
          'Personalized notification settings and real-time alerts.',
        },
      ],
      'Enterprise': [
        {
          'icon': Icons.account_circle,
          'title': 'Enterprise Profile Management',
          'description':
          'Complete profile management with SSO integration and custom fields.',
        },
        {
          'icon': Icons.storage,
          'title': 'Unlimited Storage',
          'description':
          'Unlimited cloud storage for all your enterprise needs.',
        },
        {
          'icon': Icons.headset_mic,
          'title': 'Dedicated Support',
          'description': 'Dedicated account manager and 24/7 premium support.',
        },
        {
          'icon': Icons.analytics,
          'title': 'Enterprise Analytics',
          'description':
          'Advanced business intelligence and custom reporting dashboards.',
        },
        {
          'icon': Icons.groups,
          'title': 'Unlimited Team Members',
          'description':
          'Add unlimited team members with advanced role management.',
        },
        {
          'icon': Icons.security,
          'title': 'Advanced Security',
          'description':
          'Enterprise-grade security with compliance certifications.',
        },
        {
          'icon': Icons.admin_panel_settings,
          'title': 'Admin Controls',
          'description':
          'Comprehensive admin dashboard with user management tools.',
        },
        {
          'icon': Icons.api,
          'title': 'Premium API Access',
          'description':
          'Unlimited API calls with premium endpoints and webhooks.',
        },
        {
          'icon': Icons.backup,
          'title': 'Custom Backup Solutions',
          'description':
          'Configurable backup schedules and disaster recovery options.',
        },
        {
          'icon': Icons.integration_instructions,
          'title': 'Custom Integrations',
          'description':
          'White-label solutions and custom integration development.',
        },
        {
          'icon': Icons.school,
          'title': 'Training & Onboarding',
          'description':
          'Personalized training sessions and dedicated onboarding support.',
        },
        {
          'icon': Icons.trending_up,
          'title': 'Performance Optimization',
          'description':
          'Priority infrastructure and performance optimization features.',
        },
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final plans = ['Free', 'Essential', 'Enterprise'];
    final planFeatures = getPlanFeatures();

    return DefaultTabController(
      length: plans.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '$productName Plans',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F1C35),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
          bottom: TabBar(
            tabs: plans.map((plan) => Tab(text: plan)).toList(),
            labelColor: const Color(0xFF2EC4F3),
            unselectedLabelColor: const Color(0xFF404B69),
            indicatorColor: const Color(0xFFBFD633),
            labelStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          child: Container(
            color: Colors.white.withValues(alpha: 0.1),
            child: TabBarView(
              children:
              plans.map((plan) {
                // Use the predefined features
                final features = planFeatures[plan] ?? [];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Plan header with pricing badge
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$plan Plan Features',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F1C35),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Explore the features included in the $plan plan for $productName.',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF404B69),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFBFD633),
                                  const Color(0xFF2EC4F3),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getPlanPrice(plan),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Features list
                      if (features.isEmpty)
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 48,
                                color: const Color(
                                  0xFF404B69,
                                ).withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No features available for this plan.',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF404B69),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Column(
                          children:
                          features.asMap().entries.map((entry) {
                            final feature = entry.value;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Card(
                                elevation: 2,
                                shadowColor: Colors.black.withValues(
                                  alpha: 0.1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    16,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      16,
                                    ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white,
                                        const Color(
                                          0xFFBFD633,
                                        ).withValues(alpha: 0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF2EC4F3,
                                            ).withValues(alpha: 0.1),
                                            borderRadius:
                                            BorderRadius.circular(
                                              16,
                                            ),
                                            border: Border.all(
                                              color: const Color(
                                                0xFF2EC4F3,
                                              ).withValues(alpha: 0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Icon(
                                            feature['icon'],
                                            color: const Color(
                                              0xFF2EC4F3,
                                            ),
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                feature['title'],
                                                style:
                                                GoogleFonts.montserrat(
                                                  fontSize: 18,
                                                  fontWeight:
                                                  FontWeight
                                                      .w600,
                                                  color:
                                                  const Color(
                                                    0xFF0F1C35,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                feature['description'],
                                                style:
                                                GoogleFonts.inter(
                                                  fontSize: 15,
                                                  fontWeight:
                                                  FontWeight
                                                      .w400,
                                                  color:
                                                  const Color(
                                                    0xFF404B69,
                                                  ),
                                                  height: 1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                      // Bottom spacing
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  String _getPlanPrice(String plan) {
    switch (plan) {
      case 'Free':
        return 'Free';
      case 'Essential':
        return '\$29/month';
      case 'Enterprise':
        return 'Custom Pricing';
      default:
        return 'Contact Us';
    }
  }
}
