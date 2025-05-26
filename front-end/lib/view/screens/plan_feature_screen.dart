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
    print(widget.plan1Name);
    print(widget.plan2Name);
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> getPlanData() {
    final allPlans = [
      // Scan2Hire Plans
      {
        'name': 'Freemium',
        'originalName': 'Scan2Hire Free',
        'price': 'FREE',
        'priceKES': '',
        'subtitle': '7 Days Trial',
        'description':
        'Perfect for getting started with basic recruitment needs',
        'setupFee': 'No Fee',
        'setupFeeKES': '',
        'customization': 'N/A',
        'support': 'FAQ and ticket support (mail)',
        'supportRate': 'N/A',
        'contract': '7 Days',
        'isPopular': false,
        'limits': {'Jobs': '5', 'Resume': '100', 'Users': '3', 'Credits': '50'},
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
          'Current plans': true,
          'Add Credits': true,
          'FAQ and ticket support': true,
          'Recruiter Targets': true,
          'Google Calendar Integration': false,
          'Upcoming Events': false,
          'User Management': false,
          'Add a new job': true,
          'View Job Analytics': false,
          'Job Data Parsing': false,
          'Score Weight & Graph': false,
          'Rank and Analyze': true,
          'Direct Recruiter Application': false,
          'Reassign Job': false,
          'Add Candidates': true,
          'Candidate Analytics': false,
          'Candidate Data Parsing': false,
          'Interview Management': false,
          'My Target': true,
          'View Assigned Job': true,
        },
        'color': const Color(0xFF6B7280),
        'gradient': [const Color(0xFFF3F4F6), const Color(0xFFE5E7EB)],
        'category': 'Scan2Hire',
      },
      {
        'name': 'Enterprise',
        'originalName': 'Scan2Hire Enterprise',
        'price': '\$79',
        'priceKES': 'KES 10,207',
        'subtitle': 'Per User/Month',
        'description':
        'Complete solution for large organizations with advanced features',
        'setupFee': '\$2,500',
        'setupFeeKES': 'KES 3,23,013',
        'customization': '\$15/hr',
        'customizationKES': 'KES 1,938/hr',
        'support': 'Premium Support',
        'supportRate': '15 hrs/month',
        'contract': '3 Months',
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
          'Interview Management': true,
          'My Target': true,
          'View Assigned Job': true,
        },
        'color': const Color(0xFF13477A),
        'gradient': [const Color(0xFF13477A), const Color(0xFF13477A)],
        'category': 'Scan2Hire',
      },
      // NextStaff Plans
      {
        'name': 'Freemium',
        'originalName': 'NextStaff Growth',
        'price': 'FREE',
        'priceKES': '',
        'subtitle': '14 Days Trial',
        'description': 'Perfect for small teams starting with basic HR needs',
        'setupFee': 'No Fee',
        'setupFeeKES': '',
        'customization': 'N/A',
        'support': 'Basic Support',
        'supportRate': 'N/A',
        'contract': '14 Days',
        'isPopular': false,
        'limits': {'Users': '10-25'},
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
        },
        'color': const Color(0xFF6B7280),
        'gradient': [const Color(0xFFF3F4F6), const Color(0xFFE5E7EB)],
        'category': 'NextStaff',
      },
      {
        'name': 'Enterprice',
        'originalName': 'NextStaff Premium',
        'price': '\$69',
        'priceKES': 'KES 8,913',
        'subtitle': 'Per User/Month',
        'description': 'Advanced HR features for growing businesses',
        'setupFee': '\$1,500',
        'setupFeeKES': 'KES 1,93,770',
        'customization': '\$15/hr',
        'customizationKES': 'KES 1,938/hr',
        'support': 'Premium Support',
        'supportRate': '15 hrs/month',
        'contract': '3 Months',
        'isPopular': true,
        'limits': {'Users': '50 & Above'},
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
        },
        'color': const Color(0xFF13477A),
        'gradient': [const Color(0xFF13477A), const Color(0xFF13477A)],
        'category': 'NextStaff',
      },
      // CRM Plans
      {
        'name': 'Freemimum',
        'originalName': 'CRM Growth',
        'price': '\$19',
        'priceKES': 'KES 2,455',
        'subtitle': 'Per User/Month',
        'description': 'Ideal for small teams starting with CRM features',
        'setupFee': '\$1,500',
        'setupFeeKES': 'KES 1,93,770',
        'customization': '\$15/hr',
        'customizationKES': 'KES 1,938/hr',
        'support': 'Basic Support',
        'supportRate': '10 hrs/month',
        'contract': '3 Months',
        'isPopular': false,
        'limits': {'Users': '5-25'},
        'features': {
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
          'Roles and Permission': true,
        },
        'color': const Color(0xFF6B7280),
        'gradient': [const Color(0xFFF3F4F6), const Color(0xFFE5E7EB)],
        'category': 'CRM',
      },
      {
        'name': 'Enterprise',
        'originalName': 'CRM Enterprise',
        'price': '\$29',
        'priceKES': 'KES 3,746',
        'subtitle': 'Per User/Month',
        'description': 'Advanced CRM features for growing businesses',
        'setupFee': '\$2,500',
        'setupFeeKES': 'KES 3,22,950',
        'customization': '\$15/hr',
        'customizationKES': 'KES 1,938/hr',
        'support': 'Premium Support',
        'supportRate': '15 hrs/month',
        'contract': '3 Months',
        'isPopular': true,
        'limits': {'Users': '26-50'},
        'features': {
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
          'Roles and Permission': true,
        },
        'color': const Color(0xFF13477A),
        'gradient': [const Color(0xFF13477A), const Color(0xFF13477A)],
        'category': 'CRM',
      },
      // IMS Plans
      {
        'name': 'Enterprise',
        'originalName': 'IMS Enterprise',
        'price': '\$19',
        'priceKES': 'KES 2,455',
        'subtitle': 'Per User/Month',
        'description':
        'Comprehensive IMS for efficient inventory and operations',
        'setupFee': '\$2,500',
        'setupFeeKES': 'KES 3,22,950',
        'customization': '\$15/hr',
        'customizationKES': 'KES 1,938/hr',
        'support': 'Premium Support',
        'supportRate': '15 hrs/month',
        'contract': '3 Months',
        'isPopular': true,
        'limits': {'Users': '5-50'},
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
        'color': const Color(0xFF13477A),
        'gradient': [const Color(0xFF13477A), const Color(0xFF13477A)],
        'category': 'IMS',
      },
      // Integrated Plans (S2H + NextStaff)
      {
        'name': 'SaaS Based',
        'originalName': 'Integrated SaaS',
        'price': '\$89',
        'priceKES': '',
        'subtitle': 'Per User/Month',
        'description':
        'Complete HR & Recruitment solution with SaaS flexibility',
        'setupFee': '\$1,500',
        'setupFeeKES': 'KES 3,23,013',
        'customization': '\$15/hr',
        'customizationKES': 'KES 1,938/hr',
        'support': 'Premium Support',
        'supportRate': '15 hrs/month',
        'contract': '3 Months',
        'isPopular': true,
        'limits': {'Users': '5-25'},
        'features': {
          'Employee Profile': true,
          'Attendance Tracking': true,
          'Leave Management': true,
          'Payroll Management': true,
          'Timesheet Tracking': true,
          'Company Policy': true,
          'Appraisal Review': true,
          'TL Dashboard': true,
          'Hiring Module': true,
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
        },
        'color': const Color(0xFF13477A),
        'gradient': [const Color(0xFF13477A), const Color(0xFF1E3A8A)],
        'category': 'Integrated',
      },
      {
        'name': 'One Time Cost',
        'originalName': 'Integrated One Time',
        'price': '\$63,360',
        'priceKES': '',
        'subtitle': 'One-time payment',
        'description':
        'Complete solution with unlimited users and one-time cost',
        'setupFee': '\$2,500',
        'setupFeeKES': 'KES 3,22,950',
        'customization': '\$15/hr',
        'customizationKES': 'KES 1,938/hr',
        'support': 'Premium Support',
        'supportRate': '15 hrs/month',
        'contract': 'N/A',
        'isPopular': false,
        'limits': {'Users': 'Unlimited'},
        'features': {
          'Employee Profile': true,
          'Attendance Tracking': true,
          'Leave Management': true,
          'Payroll Management': true,
          'Timesheet Tracking': true,
          'Company Policy': true,
          'Appraisal Review': true,
          'TL Dashboard': true,
          'Hiring Module': true,
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
        },
        'color': const Color(0xFF6B7280),
        'gradient': [const Color(0xFFF3F4F6), const Color(0xFFE5E7EB)],
        'category': 'Integrated',
      },

    ];

    // Get the product type based on the product name
    String? getProductType(String productName) {
      productName = productName.toLowerCase().trim();
      if (productName.contains('scan2hire') && productName.contains('s2h')) {
        return 'Scan2Hire';
      }
      if (productName==('nexstaff')) {
        return 'NextStaff';
      }
      if (productName == 'crm') {
        return 'CRM';
      }
      if (productName == 'ims') {
        return 'IMS';
      }
      if (productName == 'dukadin') {
        return null; // No plans for Dukadin
      }
      if (productName.contains('Integrated (S2H + Nexstaff)') ||
          productName.contains('s2h + nexstaff')) {
        return 'Integrated'; // Show Integrated plans for integrated product
      }
      return null;
    }

    // Get the product type from the product name
    final productType = getProductType(widget.plan1Name);

    // If no product type matches, return empty list
    if (productType == null) {
      return [];
    }

    // Filter plans based on product type
    var filteredPlans =
    allPlans.where((plan) => plan['category'] == productType).toList();

    // Sort plans - Free/Growth first, then Premium/Enterprise
    filteredPlans.sort((a, b) {
      final aName = a['name'] as String;
      final bName = b['name'] as String;
      if (aName.contains('Free') || aName.contains('Growth')) return -1;
      if (bName.contains('Free') || bName.contains('Growth')) return 1;
      return 0;
    });

    return filteredPlans;
  }

  @override
  Widget build(BuildContext context) {
    final planData = getPlanData();

    // Show message if no plans available
    if (planData.isEmpty) {
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
            '${widget.plan1Name} Pricing',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 48,
                color: const Color(0xFF64748B),
              ),
              const SizedBox(height: 16),
              Text(
                'No Plans Available',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'This product does not have any pricing plans available at the moment.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

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
          '${widget.plan1Name} Pricing',
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
                      children:
                      planData.asMap().entries.map((entry) {
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
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                isSelected
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow:
                                isSelected
                                    ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                      0.1,
                                    ),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      plan['name'],
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color:
                                        isSelected
                                            ? const Color(0xFF1E293B)
                                            : const Color(0xFF6B7280),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (plan['isPopular'])
                                    Container(
                                      margin: const EdgeInsets.only(
                                        left: 6,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: plan['color'],
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
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
                      child: _buildSelectedPlanCard(
                        planData[selectedPlanIndex],
                      ),
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
    final isIntegrated = planData['category'] == 'Integrated';

    if (isIntegrated) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 400),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.95 + (value * 0.05),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1E3A8A), // Deep blue
                    const Color(0xFF3B82F6), // Vibrant blue
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A8A).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  planData['name'],
                                  style: GoogleFonts.inter(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'S2H + NextStaff Integration',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (isPopular)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFD700),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'RECOMMENDED',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                planData['price'],
                                style: GoogleFonts.inter(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      planData['subtitle'],
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      planData['description'],
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Plan Details
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Plan Highlights
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Plan Details',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildHighlightItem(
                                'Setup Fee',
                                planData['setupFee'],
                                planData['setupFeeKES'],
                                true,
                                Icons.settings,
                              ),
                              _buildHighlightItem(
                                'Customization',
                                planData['customization'],
                                planData['customizationKES'],
                                true,
                                Icons.code,
                              ),
                              _buildHighlightItem(
                                'Support',
                                planData['support'],
                                planData['supportRate'],
                                true,
                                Icons.support_agent,
                              ),
                              _buildHighlightItem(
                                'Contract',
                                planData['contract'],
                                '',
                                true,
                                Icons.description,
                              ),
                              _buildHighlightItem(
                                'Users',
                                planData['limits']['Users'],
                                '',
                                true,
                                Icons.group,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Features
                        Text(
                          'Included Features',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Core HR Features
                        _buildFeatureCategory(
                          'Core HR Features',
                          [
                            'Employee Profile',
                            'Attendance Tracking',
                            'Leave Management',
                            'Payroll Management',
                            'Timesheet Tracking',
                            'Company Policy',
                            'Appraisal Review',
                            'TL Dashboard',
                          ],
                          planData,
                          true,
                        ),

                        // Hiring & Management
                        _buildFeatureCategory(
                          'Hiring & Management',
                          [
                            'Hiring Module',
                            'Web-Responsive Only',
                            'Full Mobile Access',
                            'Company Announcements',
                            'Asset Management',
                            'Expense Management',
                          ],
                          planData,
                          true,
                        ),

                        // Employee Services
                        _buildFeatureCategory(
                          'Employee Services',
                          [
                            'Employee Self Service Portal',
                            'Meeting Room',
                            'Holiday Calendar',
                            'Activity Log',
                            'Role Management',
                            'Roles and Permission',
                          ],
                          planData,
                          true,
                        ),

                        const SizedBox(height: 32),

                        // CTA Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFFB700)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFD700).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.snackbar(
                                '${planData['name']} Plan',
                                'Selected ${planData['name']} plan for Integrated Solution',
                                backgroundColor: const Color(0xFFFFD700),
                                colorText: const Color(0xFF1E293B),
                                margin: const EdgeInsets.all(16),
                                borderRadius: 12,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: const Color(0xFF1E293B),
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              planData['name'].contains('SaaS')
                                  ? 'Start SaaS Plan'
                                  : planData['name'].contains('One Time')
                                  ? 'Purchase One-Time'
                                  : 'Get White Label',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    // Non-Integrated Plans (Existing Design)
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
                      colors:
                      isPopular
                          ? planData['gradient']
                          : [Colors.white, Colors.white],
                    ),
                    border:
                    isPopular
                        ? null
                        : Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 2,
                    ),
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
                                      color:
                                      isPopular
                                          ? Colors.white
                                          : const Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color:
                                      isPopular
                                          ? Colors.white.withOpacity(0.2)
                                          : const Color(
                                        0xFF13477A,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:
                                        isPopular
                                            ? Colors.white.withOpacity(0.3)
                                            : const Color(
                                          0xFF13477A,
                                        ).withOpacity(0.2),
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                planData['price'],
                                                style: GoogleFonts.inter(
                                                  fontSize: 36,
                                                  fontWeight: FontWeight.w900,
                                                  color:
                                                  isPopular
                                                      ? Colors.white
                                                      : const Color(
                                                    0xFF1E293B,
                                                  ),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (planData['priceKES']
                                                .isNotEmpty) ...[
                                              const SizedBox(width: 8),
                                              Flexible(
                                                child: Text(
                                                  '(${planData['priceKES']})',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                    isPopular
                                                        ? Colors.white
                                                        .withOpacity(
                                                      0.9,
                                                    )
                                                        : const Color(
                                                      0xFF13477A,
                                                    ),
                                                  ),
                                                  overflow:
                                                  TextOverflow.ellipsis,
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
                                            color:
                                            isPopular
                                                ? Colors.white.withOpacity(
                                              0.9,
                                            )
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
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
                            color:
                            isPopular
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
                            color:
                            isPopular
                                ? Colors.white.withOpacity(0.1)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border:
                            isPopular
                                ? Border.all(
                              color: Colors.white.withOpacity(0.2),
                            )
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
                                  color:
                                  isPopular
                                      ? Colors.white
                                      : const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildPricingDetail(
                                'Setup Fee',
                                planData['setupFee'],
                                planData['setupFeeKES'],
                                isPopular,
                              ),
                              _buildPricingDetail(
                                'Customization',
                                planData['customization'],
                                '',
                                isPopular,
                              ),
                              _buildPricingDetail(
                                'Support',
                                planData['support'],
                                planData['supportRate'],
                                isPopular,
                              ),
                              _buildPricingDetail(
                                'Contract Period',
                                planData['contract'],
                                '',
                                isPopular,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Plan Limits
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                            isPopular
                                ? Colors.white.withOpacity(0.1)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border:
                            isPopular
                                ? Border.all(
                              color: Colors.white.withOpacity(0.2),
                            )
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
                                  color:
                                  isPopular
                                      ? Colors.white
                                      : const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 16,
                                runSpacing: 8,
                                children:
                                planData['limits'].entries.map<Widget>((
                                    entry,
                                    ) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                      isPopular
                                          ? Colors.white.withOpacity(
                                        0.15,
                                      )
                                          : const Color(
                                        0xFF10B981,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          size: 16,
                                          color:
                                          isPopular
                                              ? Colors.white
                                              : const Color(0xFF10B981),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${entry.value} ${entry.key}',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color:
                                            isPopular
                                                ? Colors.white
                                                : const Color(
                                              0xFF10B981,
                                            ),
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
                            color:
                            isPopular
                                ? Colors.white
                                : const Color(0xFF1E293B),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Feature Categories
                        if (planData['category'] == 'Scan2Hire') ...[
                          _buildFeatureCategory(
                            'Admin Dashboard',
                            [
                              'Time to fill',
                              'Total Jobs',
                              'Total Candidates',
                              'Total Credits',
                              'Time to Hire',
                              'Activity Log',
                              'Recruiter Activity',
                              'Credit Usage',
                              'Candidates Overview',
                              'Candidate Pipeline History',
                              'Employee Performance',
                              'Notifications',
                            ],
                            planData,
                            isPopular,
                          ),
                          _buildFeatureCategory(
                            'User Management',
                            ['Add users', 'Current plans', 'Add Credits'],
                            planData,
                            isPopular,
                          ),
                          _buildFeatureCategory(
                            'Job Management',
                            [
                              'Add a new job',
                              'View Job Analytics',
                              'Job Data Parsing',
                              'Score Weight & Graph',
                              'Rank and Analyze',
                              'Direct Recruiter Application',
                              'Reassign Job',
                            ],
                            planData,
                            isPopular,
                          ),
                          _buildFeatureCategory(
                            'Candidate Management',
                            [
                              'Add Candidates',
                              'Candidate Analytics',
                              'Candidate Data Parsing',
                              'Interview Management',
                            ],
                            planData,
                            isPopular,
                          ),
                          _buildFeatureCategory(
                            'Support',
                            ['FAQ and ticket support'],
                            planData,
                            isPopular,
                          ),
                        ] else if (planData['category'] == 'NextStaff') ...[
                          _buildFeatureCategory(
                            'Core Features',
                            [
                              'Employee Profile',
                              'Attendance Tracking',
                              'Leave Management',
                              'Payroll Management',
                              'Timesheet Tracking',
                              'Company Policy',
                              'Appraisal Review',
                              'TL Dashboard',
                            ],
                            planData,
                            isPopular,
                          ),
                          _buildFeatureCategory(
                            'Access & Management',
                            [
                              'Web-Responsive Only',
                              'Full Mobile Access',
                              'Company Announcements',
                              'Asset Management',
                              'Expense Management',
                              'Employee Self Service Portal',
                              'Meeting Room',
                              'Holiday Calendar',
                              'Activity Log',
                              'Role Management',
                              'Roles and Permission',
                            ],
                            planData,
                            isPopular,
                          ),
                        ] else if (planData['category'] == 'CRM') ...[
                          _buildFeatureCategory(
                            'Performance & Tracking',
                            [
                              'Team Performance',
                              'Target Assignment',
                              'Reminders & Tasks',
                              'Quantity Record',
                              'Call log track',
                              'Lead Overview',
                              'Individual Performance Track',
                              'Sales Tracking by Time Period',
                            ],
                            planData,
                            isPopular,
                          ),
                          _buildFeatureCategory(
                            'Core CRM Features',
                            [
                              'Calendar',
                              'Leads Management',
                              'Customer Management',
                              'Tasks',
                              'Proposals',
                              'Product Management',
                              'Staff Management',
                              'Lead Status Module',
                              'Roles and Permission',
                            ],
                            planData,
                            isPopular,
                          ),
                        ] else if (planData['category'] == 'IMS') ...[
                          _buildFeatureCategory(
                            'Unloading Management',
                            [
                              'Gate Entry',
                              'Supplier Bill Detail',
                              'Concern Pending',
                              'PD Approval',
                              'Unload Completion',
                              'Unloaded Gatepasses',
                              'All Unloaded',
                            ],
                            planData,
                            isPopular,
                          ),
                          _buildFeatureCategory(
                            'Loading Management',
                            [
                              'Do An Order',
                              'Loading Approval',
                              'Loading Completion',
                              'Customer Detail',
                              'Loading Gatepass Exit',
                              'Direct Sale',
                              'All Loaded',
                            ],
                            planData,
                            isPopular,
                          ),
                          _buildFeatureCategory(
                            'Purchase & Lab',
                            [
                              'All Purchases',
                              'Transportation',
                              'Unloading vehicles',
                              'Loading vehicles',
                              'Raise Test',
                              'All Lab check',
                            ],
                            planData,
                            isPopular,
                          ),
                          _buildFeatureCategory(
                            'Approval & Samples',
                            [
                              'Unload Approval',
                              'Load Approval',
                              'Batch Assign',
                              'Samples',
                              'Couriers',
                            ],
                            planData,
                            isPopular,
                          ),
                          _buildFeatureCategory(
                            'Inventory Management',
                            [
                              'All Sale',
                              'Unload Report',
                              'Add/Edit/View product inventory',
                              'Built-in calculator with simple and detail mode',
                              'Product sell purchase data',
                              'Add/Edit/Delete staff members',
                            ],
                            planData,
                            isPopular,
                          ),
                        ] else if (planData['category'] == 'Integrated') ...[
                          _buildFeatureCategory(
                            'Core HR Features',
                            [
                              'Employee Profile',
                              'Attendance Tracking',
                              'Leave Management',
                              'Payroll Management',
                              'Timesheet Tracking',
                              'Company Policy',
                              'Appraisal Review',
                              'TL Dashboard',
                            ],
                            planData,
                            isPopular,
                          ),
                          _buildFeatureCategory(
                            'Hiring & Management',
                            [
                              'Hiring Module',
                              'Web-Responsive Only',
                              'Full Mobile Access',
                              'Company Announcements',
                              'Asset Management',
                              'Expense Management',
                            ],
                            planData,
                            isPopular,
                          ),
                          _buildFeatureCategory(
                            'Employee Services',
                            [
                              'Employee Self Service Portal',
                              'Meeting Room',
                              'Holiday Calendar',
                              'Activity Log',
                              'Role Management',
                              'Roles and Permission',
                            ],
                            planData,
                            isPopular,
                          ),
                        ],

                        const SizedBox(height: 32),

                        // CTA Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors:
                              isPopular
                                  ? [
                                Colors.white,
                                Colors.white.withOpacity(0.9),
                              ]
                                  : [
                                planData['color'],
                                planData['color'].withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: (isPopular
                                    ? Colors.white
                                    : planData['color'])
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.snackbar(
                                '${planData['name']} Plan',
                                'Selected ${planData['name']} plan for ${planData['category']}',
                                backgroundColor: planData['color'],
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(16),
                                borderRadius: 12,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor:
                              isPopular ? planData['color'] : Colors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              planData['name'].contains('Freemium')
                                  ? 'Start Free Trial'
                                  : 'Contact Sales',
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

  Widget _buildPricingDetail(
      String label,
      String value,
      String kenyaValue,
      bool isPopular,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color:
                isPopular
                    ? Colors.white.withOpacity(0.9)
                    : const Color(0xFF64748B),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isPopular ? Colors.white : const Color(0xFF1E293B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (kenyaValue.isNotEmpty)
                  Text(
                    kenyaValue,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color:
                      isPopular
                          ? Colors.white.withOpacity(0.8)
                          : const Color(0xFF64748B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCategory(
      String title,
      List<String> features,
      Map<String, dynamic> planData,
      bool isPopular,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
        isPopular
            ? Colors.white.withOpacity(0.05)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border:
        isPopular ? Border.all(color: Colors.white.withOpacity(0.1)) : null,
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
                    color:
                    isAvailable
                        ? (isPopular
                        ? Colors.white
                        : const Color(0xFF10B981))
                        : (isPopular
                        ? Colors.white.withOpacity(0.5)
                        : const Color(0xFFEF4444)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color:
                        isAvailable
                            ? (isPopular
                            ? Colors.white.withOpacity(0.95)
                            : const Color(0xFF374151))
                            : (isPopular
                            ? Colors.white.withOpacity(0.6)
                            : const Color(0xFF9CA3AF)),
                        decoration:
                        isAvailable ? null : TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(
      String label,
      String value,
      String subValue,
      bool isPopular,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
              isPopular
                  ? Colors.white.withOpacity(0.1)
                  : const Color(0xFF1E40AF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isPopular ? Colors.white : const Color(0xFF1E40AF),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color:
                    isPopular
                        ? Colors.white.withOpacity(0.8)
                        : const Color(0xFF64748B),
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isPopular ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                if (subValue.isNotEmpty)
                  Text(
                    subValue,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color:
                      isPopular
                          ? Colors.white.withOpacity(0.7)
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
}
