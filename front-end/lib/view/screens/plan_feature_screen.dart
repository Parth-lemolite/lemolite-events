import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EnhancedPricingScreen extends StatefulWidget {
  final String plan1Name;
  final String plan2Name;

  const EnhancedPricingScreen({
    super.key,
    required this.plan1Name,
    required this.plan2Name,
  });

  @override
  State<EnhancedPricingScreen> createState() => _EnhancedPricingScreenState();
}

class _EnhancedPricingScreenState extends State<EnhancedPricingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int selectedPlanIndex = 0; // Default to first plan

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> getPlanData() {
    final allPlans = [
      {
        'name': 'NextStaff Freemium',
        'originalName': 'Free',
        'price': 'FREE',
        'priceKES': '',
        'subtitle': '7 Days Trial',
        'description': 'Perfect for getting started with basic recruitment needs',
        'setupFee': 'No Fee',
        'setupFeeKES': '',
        'customization': 'N/A',
        'support': 'FAQ and ticket support (mail)',
        'supportRate': 'N/A',
        'supportHours': '7 Days',
        'contract': '7 Days',
        'isPopular': false,
        'limits': {
          'Jobs': '5',
          'Resume': '100',
          'Users': '3',
          'Credits': '50',
        },
        'features': {
          'Time to fill': false,
          'Total Jobs': true,
          'Total Candidates': true,
          'Total Credits': true,
          'Time to Hire': false,
          'Activity Log': false,
          'Recruiter Activity': false,
          'Credit Usage': false,
          'Candidates Overview': false,
          'Candidate Pipeline History': false,
          'Employee Performance': false,
          'Notifications': false,
          'Add users': false,
          'Current plans': false,
          'Add Credits': false,
          'FAQ and ticket support': true,
          'Recruiter Targets': false,
          'Google Calendar Integration': false,
          'Notifications Management': false,
          'Upcoming Events': false,
          'User Management': false,
          'Add a new job': true,
          'View Job Analytics': false,
          'Job Data Parsing': false,
          'Score Weight & Graph': false,
          'Rank and Analyze': false,
          'Direct Recruiter Application': false,
          'Reassign Job': false,
          'Add Candidates': true,
          'Candidate Analytics': false,
          'Candidate Data Parsing': false,
          'Candidate Rank and Analyze': false,
          'Interview Management': false,
          'My Target': false,
          'View Assigned Job': false,
        },
        'color': const Color(0xFF6B7280),
        'gradient': [const Color(0xFFF3F4F6), const Color(0xFFE5E7EB)],
        'category': 'Recruitment',
      },
      {
        'name': 'NextStaff Enterprise',
        'originalName': 'Enterprise',
        'price': '\$79',
        'priceKES': 'KES 10,207',
        'subtitle': 'Per User/Month',
        'description': 'Complete solution for large organizations with advanced features',
        'setupFee': '\$2,500',
        'setupFeeKES': 'KES 3,23,013',
        'customization': '\$15/hr',
        'customizationKES': 'KES 1,938/hr',
        'support': 'Premium Support',
        'supportRate': '15 hrs/month',
        'contract': '3 Months Minimum',
        'isPopular': true,
        'limits': {
          'Jobs': '1,000',
          'Resume': '5,000',
          'Users': '50',
          'Credits': '5,000',
        },
        'features': {
          'Time to fill': true,
          'Total Jobs': true,
          'Total Candidates': true,
          'Total Credits': true,
          'Time to Hire': true,
          'Activity Log': true,
          'Recruiter Activity': true,
          'Credit Usage': true,
          'Candidates Overview': true,
          'Candidate Pipeline History': true,
          'Employee Performance': true,
          'Notifications': true,
          'Add users': true,
          'Current plans': true,
          'Add Credits': true,
          'FAQ and ticket support': true,
          'Recruiter Targets': true,
          'Google Calendar Integration': true,
          'Notifications Management': true,
          'Upcoming Events': true,
          'User Management': true,
          'Add a new job': true,
          'View Job Analytics': true,
          'Job Data Parsing': true,
          'Score Weight & Graph': true,
          'Rank and Analyze': true,
          'Direct Recruiter Application': true,
          'Reassign Job': true,
          'Add Candidates': true,
          'Candidate Analytics': true,
          'Candidate Data Parsing': true,
          'Candidate Rank and Analyze': true,
          'Interview Management': true,
          'My Target': true,
          'View Assigned Job': true,
        },
        'color': const Color(0xFF13477A),
        'gradient': [const Color(0xFF13477A), const Color(0xFF13477A)],
        'category': 'Recruitment',
      },
      {
        'name': 'NextStaff Freemium',
        'originalName': 'CRM Growth',
        'price': 'FREE',
        'priceKES': '',
        'subtitle': '14 Days Trial',
        'description': 'Ideal for small teams starting with CRM features',
        'setupFee': 'No Fee',
        'setupFeeKES': '',
        'customization': 'N/A',
        'support': 'Basic Support',
        'supportRate': 'N/A',
        'supportHours': '14 Days',
        'contract': '14 Days',
        'isPopular': false,
        'limits': {
          'Users': '10–25',
        },
        'features': {
          'Employee Profile': true,
          'Attendance Tracking': true,
          'Leave Management': true,
          'Payroll Management': false,
          'Timesheet Tracking': true,
          'Company Policy': true,
          'Appraisal Review': false,
          'TL Dashboard': false,
          'Web-Responsive Only': true,
          'Full Mobile Access': false,
          'Company Announcements': false,
          'Asset Management': false,
          'Expense Management': false,
          'Employee Self Service Portal': true,
          'Meeting Room': false,
          'Holiday Calendar': true,
          'Activity Log': false,
          'Role Management': false,
          'Roles and Permission': false,
          'Team Performance': true,
          'Target Assignment': true,
          'Reminders & Tasks': true,
          'Quantity Record': true,
          'Call log track': false,
          'Lead Overview': true,
          'Individual Performance Track': true,
          'Sales Tracking by Time Period': false,
          'Calendar': true,
          'Leads Management': true,
          'Customer Management': true,
          'Tasks': false,
          'Proposals': false,
          'Product Management': true,
          'Staff Management': true,
          'Lead Status Module': true,
        },
        'color': const Color(0xFF6B7280),
        'gradient': [const Color(0xFFF3F4F6), const Color(0xFFE5E7EB)],
        'category': 'CRM',
      },
      {
        'name': 'NextStaff Enterprise',
        'originalName': 'CRM Premium',
        'price': '\$69',
        'priceKES': 'KES 8,915',
        'subtitle': 'Per User/Month',
        'description': 'Advanced CRM features for growing businesses',
        'setupFee': '\$1,500',
        'setupFeeKES': 'KES 3,23,013',
        'customization': '\$15/hr',
        'customizationKES': 'KES 1,938/hr',
        'support': 'Premium Support',
        'supportRate': '15 hrs/month',
        'contract': '3 Months Minimum',
        'isPopular': true,
        'limits': {
          'Users': '50 & Above',
        },
        'features': {
          'Employee Profile': true,
          'Attendance Tracking': true,
          'Leave Management': true,
          'Payroll Management': true,
          'Timesheet Tracking': true,
          'Company Policy': true,
          'Appraisal Review': true,
          'TL Dashboard': true,
          'Web-Responsive Only': true,
          'Full Mobile Access': true,
          'Company Announcements': true,
          'Asset Management': true,
          'Expense Management': true,
          'Employee Self Service Portal': true,
          'Meeting Room': true,
          'Holiday Calendar': true,
          'Activity Log': true,
          'Role Management': true,
          'Roles and Permission': true,
          'Team Performance': true,
          'Target Assignment': true,
          'Reminders & Tasks': true,
          'Quantity Record': true,
          'Call log track': true,
          'Lead Overview': true,
          'Individual Performance Track': true,
          'Sales Tracking by Time Period': true,
          'Calendar': true,
          'Leads Management': true,
          'Customer Management': true,
          'Tasks': true,
          'Proposals': true,
          'Product Management': true,
          'Staff Management': true,
          'Lead Status Module': true,
        },
        'color': const Color(0xFF2EC4F3),
        'gradient': [const Color(0xFF2EC4F3), const Color(0xFF2EC4F3)],
        'category': 'CRM',
      },
      {
        'name': 'NextStaff Enterprise',
        'originalName': 'IMS Enterprise',
        'price': '\$19',
        'priceKES': 'KES 2,455',
        'subtitle': 'Per User/Month',
        'description': 'Comprehensive IMS for efficient inventory and operations',
        'setupFee': '\$2,500',
        'setupFeeKES': 'KES 3,23,013',
        'customization': '\$15/hr',
        'customizationKES': 'KES 1,938/hr',
        'support': 'Premium Support',
        'supportRate': '15 hrs/month',
        'contract': '3 Months Minimum',
        'isPopular': true,
        'limits': {
          'Users': '5–50',
        },
        'features': {
          'Gate Entry': true,
          'Supplier Bill Detail': true,
          'Concern Pending': true,
          'PD Approval': true,
          'Unload Completion': true,
          'Unloaded Gatepasses': true,
          'All Unloaded': true,
          'Do An Order': true,
          'Loading Approval': true,
          'Loading Completion': true,
          'Customer Detail': true,
          'Loading Gatepass Exit': true,
          'Direct Sale': true,
          'All Loaded': true,
          'All Purchases': true,
          'Transportation': true,
          'Unloading vehicles': true,
          'Loading vehicles': true,
          'Raise Test': true,
          'All Lab check': true,
          'Unload Approval': true,
          'Load Approval': true,
          'Batch Assign': true,
          'Samples': true,
          'Couriers': true,
          'All Sale': true,
          'Unload Report': true,
          'Add/Edit/View product inventory': true,
          'Built-in calculator with simple and detail mode': true,
          'Product sell purchase data': true,
          'Add/Edit/Delete staff members': true,
        },
        'color': const Color(0xFF10B981),
        'gradient': [const Color(0xFF10B981), const Color(0xFF10B981)],
        'category': 'IMS',
      },
    ];

    // Normalize input plan names by removing "NextStaff" prefix for filtering
    final plan1 = widget.plan1Name.replaceAll('NextStaff ', '');
    final plan2 = widget.plan2Name.replaceAll('NextStaff ', '');

    // Filter plans based on category and input plan names
    final filteredPlans = allPlans.where((plan) {
      final planName = (plan['name'] as String?)?.replaceAll('NextStaff ', '') ?? '';
      final originalName = (plan['originalName'] as String?) ?? '';
      final isMatchingPlan = (planName == plan1 || planName == plan2) &&
          !originalName.contains('White Label');
      // For IMS, only include Enterprise if plan1 is Enterprise
      if (plan['category'] == 'IMS') {
        return planName == 'Enterprise' && plan1 == 'Enterprise';
      }
      return isMatchingPlan;
    }).toList();

    // Ensure only up to two plans are returned
    return filteredPlans.length > 2 ? filteredPlans.sublist(0, 2) : filteredPlans;
  }

  @override
  Widget build(BuildContext context) {
    final planData = getPlanData();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E293B)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'NextStaff Pricing',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      children: [
                        Text(
                          'Choose Your Plan',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select a plan tailored for Recruitment, CRM, or IMS needs',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF64748B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Plan Selector Tabs
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: planData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final plan = entry.value;
                        final isSelected = selectedPlanIndex == index;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPlanIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: isSelected
                                    ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    plan['name'],
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFF6B7280),
                                    ),
                                  ),
                                  if (plan['isPopular'])
                                    Container(
                                      margin: const EdgeInsets.only(left: 6),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: plan['color'],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        'POPULAR',
                                        style: GoogleFonts.inter(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Selected Plan Details
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildSelectedPlanCard(planData[selectedPlanIndex]),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedPlanCard(Map<String, dynamic> planData) {
    final isPopular = planData['isPopular'];

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (value * 0.05),
          child: Opacity(
            opacity: value,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: planData['color'].withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isPopular
                          ? planData['gradient']
                          : [Colors.white, Colors.white],
                    ),
                    border: isPopular
                        ? null
                        : Border.all(color: const Color(0xFFE2E8F0), width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Plan Header with Highlighted Pricing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    planData['name'],
                                    style: GoogleFonts.inter(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: isPopular ? Colors.white : const Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isPopular
                                          ? Colors.white.withOpacity(0.2)
                                          : const Color(0xFF13477A).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isPopular
                                            ? Colors.white.withOpacity(0.3)
                                            : const Color(0xFF13477A).withOpacity(0.2),
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              planData['price'],
                                              style: GoogleFonts.inter(
                                                fontSize: 36,
                                                fontWeight: FontWeight.w900,
                                                color: isPopular ? Colors.white : const Color(0xFF1E293B),
                                              ),
                                            ),
                                            if (planData['priceKES'].isNotEmpty) ...[
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  '(${planData['priceKES']})',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: isPopular
                                                        ? Colors.white.withOpacity(0.9)
                                                        : const Color(0xFF13477A),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        Text(
                                          planData['subtitle'],
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isPopular
                                                ? Colors.white.withOpacity(0.9)
                                                : const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isPopular)
                              Container(
                                margin: const EdgeInsets.only(left: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'POPULAR',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          planData['description'],
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: isPopular
                                ? Colors.white.withOpacity(0.9)
                                : const Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Pricing Details
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isPopular
                                ? Colors.white.withOpacity(0.1)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: isPopular
                                ? Border.all(color: Colors.white.withOpacity(0.2))
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pricing Details',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isPopular
                                      ? Colors.white
                                      : const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildPricingRow('Setup Fee', planData['setupFee'], planData['setupFeeKES'], isPopular),
                              if (planData['customization'] != 'N/A')
                                _buildPricingRow('Customization', planData['customization'], planData['customizationKES'], isPopular),
                              _buildPricingRow('Support', planData['support'], planData['supportRate'], isPopular),
                              _buildPricingRow('Min Contract', planData['contract'], '', isPopular),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Plan Limits
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isPopular
                                ? Colors.white.withOpacity(0.1)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: isPopular
                                ? Border.all(color: Colors.white.withOpacity(0.2))
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Plan Limits',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isPopular
                                      ? Colors.white
                                      : const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 16,
                                runSpacing: 8,
                                children: planData['limits'].entries.map<Widget>((entry) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isPopular
                                          ? Colors.white.withOpacity(0.15)
                                          : const Color(0xFF10B981).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          size: 16,
                                          color: isPopular
                                              ? Colors.white
                                              : const Color(0xFF10B981),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${entry.value} ${entry.key}',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: isPopular
                                                ? Colors.white
                                                : const Color(0xFF10B981),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Features
                        Text(
                          'All Features',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isPopular ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Feature Categories
                        if (planData['category'] == 'Recruitment')
                          ...[
                            _buildFeatureCategory('Dashboard Features', [
                              'Time to fill', 'Total Jobs', 'Total Candidates', 'Total Credits',
                              'Time to Hire', 'Activity Log', 'Recruiter Activity', 'Credit Usage',
                              'Candidates Overview', 'Candidate Pipeline History', 'Employee Performance',
                              'Notifications', 'Add users', 'Current plans', 'Add Credits'
                            ], planData, isPopular),
                            _buildFeatureCategory('Job Management', [
                              'Add a new job', 'View Job Analytics', 'Job Data Parsing',
                              'Score Weight & Graph', 'Rank and Analyze', 'Direct Recruiter Application',
                              'Reassign Job'
                            ], planData, isPopular),
                            _buildFeatureCategory('Candidate Management', [
                              'Add Candidates', 'Candidate Analytics', 'Candidate Data Parsing',
                              'Candidate Rank and Analyze', 'Interview Management'
                            ], planData, isPopular),
                            _buildFeatureCategory('Admin & Integration', [
                              'Recruiter Targets', 'Google Calendar Integration', 'Notifications Management',
                              'Upcoming Events', 'User Management', 'My Target', 'View Assigned Job'
                            ], planData, isPopular),
                            _buildFeatureCategory('Support', [
                              'FAQ and ticket support'
                            ], planData, isPopular),
                          ]
                        else if (planData['category'] == 'CRM')
                          ...[
                            _buildFeatureCategory('Core Features', [
                              'Employee Profile', 'Attendance Tracking', 'Leave Management',
                              'Payroll Management', 'Timesheet Tracking', 'Company Policy',
                              'Appraisal Review', 'TL Dashboard'
                            ], planData, isPopular),
                            _buildFeatureCategory('Access & Management', [
                              'Web-Responsive Only', 'Full Mobile Access', 'Company Announcements',
                              'Asset Management', 'Expense Management', 'Employee Self Service Portal',
                              'Meeting Room', 'Holiday Calendar', 'Activity Log', 'Role Management',
                              'Roles and Permission'
                            ], planData, isPopular),
                            _buildFeatureCategory('CRM Features', [
                              'Team Performance', 'Target Assignment', 'Reminders & Tasks',
                              'Quantity Record', 'Call log track', 'Lead Overview',
                              'Individual Performance Track', 'Sales Tracking by Time Period',
                              'Calendar', 'Leads Management', 'Customer Management', 'Tasks',
                              'Proposals', 'Product Management', 'Staff Management', 'Lead Status Module'
                            ], planData, isPopular),
                          ]
                        else if (planData['category'] == 'IMS')
                            ...[
                              _buildFeatureCategory('Unloading', [
                                'Gate Entry', 'Supplier Bill Detail', 'Concern Pending',
                                'PD Approval', 'Unload Completion', 'Unloaded Gatepasses', 'All Unloaded'
                              ], planData, isPopular),
                              _buildFeatureCategory('Loading', [
                                'Do An Order', 'Loading Approval', 'Loading Completion',
                                'Customer Detail', 'Loading Gatepass Exit', 'Direct Sale', 'All Loaded'
                              ], planData, isPopular),
                              _buildFeatureCategory('Purchase & Lab', [
                                'All Purchases', 'PD Approval', 'Transportation',
                                'Unloading vehicles', 'Loading vehicles', 'Raise Test', 'All Lab check'
                              ], planData, isPopular),
                              _buildFeatureCategory('Approval & Samples', [
                                'Concern Pending', 'Unload Approval', 'Load Approval', 'Batch Assign',
                                'Samples', 'Couriers'
                              ], planData, isPopular),
                              _buildFeatureCategory('Accounting & Inventory', [
                                'All Sale', 'Unload Report', 'Add/Edit/View product inventory',
                                'Built-in calculator with simple and detail mode', 'Product sell purchase data',
                                'Add/Edit/Delete staff members'
                              ], planData, isPopular),
                            ],

                        const SizedBox(height: 32),

                        // CTA Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isPopular
                                  ? [Colors.white, Colors.white.withOpacity(0.9)]
                                  : [planData['color'], planData['color'].withOpacity(0.8)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: (isPopular ? Colors.white : planData['color']).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.snackbar(
                                '${planData['name']} Plan',
                                'Selected ${planData['name']} plan for NextStaff',
                                backgroundColor: planData['color'],
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(16),
                                borderRadius: 12,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: isPopular
                                  ? planData['color']
                                  : Colors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              planData['name'].contains('Freemium') ? 'Start Free Trial' : 'Contact Sales',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPricingRow(String label, String value, String kenyaValue, bool isPopular) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isPopular
                  ? Colors.white.withOpacity(0.9)
                  : const Color(0xFF64748B),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isPopular
                        ? Colors.white
                        : const Color(0xFF1E293B),
                  ),
                ),
                if (kenyaValue.isNotEmpty)
                  Text(
                    kenyaValue,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isPopular
                          ? Colors.white.withOpacity(0.8)
                          : const Color(0xFF64748B),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCategory(String title, List<String> features, Map<String, dynamic> planData, bool isPopular) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPopular
            ? Colors.white.withOpacity(0.05)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: isPopular
            ? Border.all(color: Colors.white.withOpacity(0.1))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isPopular ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          ...features.map((feature) {
            final isAvailable = planData['features'][feature] ?? false;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Icon(
                    isAvailable ? Icons.check_circle : Icons.cancel,
                    size: 16,
                    color: isAvailable
                        ? (isPopular ? Colors.white : const Color(0xFF10B981))
                        : (isPopular ? Colors.white.withOpacity(0.5) : const Color(0xFFEF4444)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isAvailable
                            ? (isPopular ? Colors.white.withOpacity(0.95) : const Color(0xFF374151))
                            : (isPopular ? Colors.white.withOpacity(0.6) : const Color(0xFF9CA3AF)),
                        decoration: isAvailable ? null : TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}