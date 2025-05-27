import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../models/lead.dart';
import 'logic.dart';
import 'state.dart';

class LeadsScreenPage extends StatelessWidget {
  LeadsScreenPage({super.key});

  final Leads_screenLogic logic = Get.put(Leads_screenLogic());
  final Leads_screenState state = Get.find<Leads_screenLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200, // Matches LandingScreen
      body: Stack(
        children: [
          Container(
            color: Colors.white.withValues(alpha: 0.1), // Subtle overlay
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App Bar
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 160,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFBFD633), Color(0xFF2EC4F3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color:
                                      Colors.white.withValues(alpha: 0.9),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.08),
                                          blurRadius: 24,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.insights_outlined,
                                      color: Color(0xFF0F1C35),
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Leads Dashboard',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF0F1C35),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Manage your business leads',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: const Color(0xFF404B69),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      color:
                                      Colors.white.withValues(alpha: 0.9),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.08),
                                          blurRadius: 24,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_outlined,
                                          color: Color(0xFF0F1C35),
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          DateFormat('MMM dd, yyyy')
                                              .format(DateTime.now()),
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF0F1C35),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Main Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quick Stats Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Obx(() => _buildQuickStatsCard(
                                state.leads,
                              )),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: Obx(() => _buildCategoryDistributionCard(
                                state.leads,
                              )),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Filter and Search Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Search Bar
                              Obx(() => TextField(
                                onChanged: (value) =>
                                state.searchQuery.value = value,
                                decoration: InputDecoration(
                                  hintText: 'Search leads...',
                                  hintStyle: GoogleFonts.inter(
                                    color: const Color(0xFF4A5568),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Color(0xFF2EC4F3),
                                  ),
                                  suffixIcon: state
                                      .searchQuery.value.isNotEmpty
                                      ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Color(0xFF4A5568),
                                    ),
                                    onPressed: () {
                                      state.searchQuery.value = '';
                                      FocusScope.of(context)
                                          .unfocus();
                                    },
                                  )
                                      : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 16),
                                ),
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF0F1C35),
                                  fontSize: 14,
                                ),
                              )),
                              const SizedBox(height: 16),
                              // Filter Chips
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Obx(() => _buildModernFilterChip(
                                      'All Leads',
                                      state.selectedCategory.value == null,
                                      Icons.filter_list,
                                          () => state.selectedCategory.value =
                                      null,
                                    )),
                                    const SizedBox(width: 12),
                                    Obx(() => _buildModernFilterChip(
                                      'Products',
                                      state.selectedCategory.value ==
                                          InterestedIn.PRODUCT,
                                      Icons.shopping_cart_outlined,
                                          () => state.selectedCategory.value =
                                          InterestedIn.PRODUCT,
                                    )),
                                    const SizedBox(width: 12),
                                    Obx(() => _buildModernFilterChip(
                                      'Services',
                                      state.selectedCategory.value ==
                                          InterestedIn.SERVICE,
                                      Icons.miscellaneous_services_outlined,
                                          () => state.selectedCategory.value =
                                          InterestedIn.SERVICE,
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Leads List
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Text(
                                      'Lead Details',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0F1C35),
                                      ),
                                    ),
                                    const Spacer(),
                                    Obx(() => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '${state.leads.where((lead) {
                                          final categoryMatch = state
                                              .selectedCategory
                                              .value ==
                                              null ||
                                              lead.interestedIn ==
                                                  state.selectedCategory
                                                      .value;
                                          final query = state
                                              .searchQuery.value
                                              .toLowerCase();
                                          final searchMatch = query
                                              .isEmpty ||
                                              (lead.companyName
                                                  ?.toLowerCase()
                                                  .contains(query) ??
                                                  false) ||
                                              (lead.fullName
                                                  ?.toLowerCase()
                                                  .contains(query) ??
                                                  false) ||
                                              (lead.email
                                                  ?.toLowerCase()
                                                  .contains(query) ??
                                                  false) ||
                                              (lead.phoneNumber
                                                  ?.toLowerCase()
                                                  .contains(query) ??
                                                  false);
                                          return categoryMatch &&
                                              searchMatch;
                                        }).length} Leads',
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFF2EC4F3),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              const Divider(
                                  height: 1, color: Color(0xFFE5E7EB)),
                              Obx(() => _buildLeadsCardList(
                                state.leads.where((lead) {
                                  final categoryMatch =
                                      state.selectedCategory.value ==
                                          null ||
                                          lead.interestedIn ==
                                              state.selectedCategory.value;
                                  final query =
                                  state.searchQuery.value.toLowerCase();
                                  final searchMatch = query.isEmpty ||
                                      (lead.companyName
                                          ?.toLowerCase()
                                          .contains(query) ??
                                          false) ||
                                      (lead.fullName
                                          ?.toLowerCase()
                                          .contains(query) ??
                                          false) ||
                                      (lead.email
                                          ?.toLowerCase()
                                          .contains(query) ??
                                          false) ||
                                      (lead.phoneNumber
                                          ?.toLowerCase()
                                          .contains(query) ??
                                          false);
                                  return categoryMatch && searchMatch;
                                }).toList(),
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadsCardList(List<Datum> filteredLeads) {
    if (filteredLeads.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            const Icon(
              Icons.search_off_outlined,
              size: 64,
              color: Color(0xFF2EC4F3),
            ),
            const SizedBox(height: 16),
            Text(
              'No leads found',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F1C35),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search terms',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF404B69),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: filteredLeads.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final lead = filteredLeads[index];
        return AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(milliseconds: 300 + (index * 100)),
          child: _buildLeadCard(lead),
        );
      },
    );
  }

  Widget _buildLeadCard(Datum lead) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead.companyName ?? 'No Company Name',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F1C35),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lead ID: ${lead.id ?? 'N/A'}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF4A5568),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          lead.interestedIn == InterestedIn.PRODUCT
                              ? const Color(0xFFBFD633)
                              : const Color(0xFF2EC4F3),
                          lead.interestedIn == InterestedIn.PRODUCT
                              ? const Color(0xFFA4C639)
                              : const Color(0xFF1A8BB3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      interestedInValues[lead.interestedIn] ?? 'N/A',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusValues[lead.status] ?? 'Active',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF404B69),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Contact and Amount Row
          Row(
            children: [
              // Contact Information
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 16,
                          color: Color(0xFF2EC4F3),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Contact Information',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF404B69),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Name: ${lead.fullName}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0F1C35),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Email: ${lead.email}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF4A5568),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Phone: ${lead.phoneNumber}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF4A5568),
                      ),
                    ),
                  ],
                ),
              ),

              // Amount Information
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 16,
                          color: Color(0xFFBFD633),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Amount',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF404B69),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${_formatAmount(lead.totalAmount?.toDouble() ?? 0)}', // Changed ₹ to $
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFBFD633),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Products Section
          if (lead.interestedIn == InterestedIn.PRODUCT) ...[
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      size: 16,
                      color: Color(0xFF2EC4F3),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Selected Products',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF404B69),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (lead.selectedProducts != null &&
                    lead.selectedProducts!.isNotEmpty) ...[
                  ...lead.selectedProducts!.map((product) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productNameValues[product.productName] ??
                                      product.productName ??
                                      'No Product Name',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF0F1C35),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Users: ${userCountRangeValues[product.userCountRange] ?? product.userCountRange ?? 'N/A'}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFF4A5568),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${_formatAmount(product.totalPrice?.toDouble() ?? 0)}', // Changed ₹ to $
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFBFD633),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ] else ...[
                  Text(
                    'No products selected',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF4A5568),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickStatsCard(List<Datum> leads) {
    final totalAmount =
    leads.fold<double>(0, (sum, lead) => sum + (lead.totalAmount ?? 0));
    final productLeads =
        leads.where((lead) => lead.interestedIn == InterestedIn.PRODUCT).length;
    final serviceLeads =
        leads.where((lead) => lead.interestedIn == InterestedIn.SERVICE).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Overview',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F1C35),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total Leads',
                  leads.length.toString(),
                  Icons.people_outline,
                  const Color(0xFF2EC4F3),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  'Product Leads',
                  productLeads.toString(),
                  Icons.shopping_bag_outlined,
                  const Color(0xFFBFD633),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  'Service Leads',
                  serviceLeads.toString(),
                  Icons.build_outlined,
                  const Color(0xFF2EC4F3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFBFD633), Color(0xFF2EC4F3)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Revenue',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF404B69),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${_formatAmount(totalAmount)}', // Changed ₹ to $
                        style: GoogleFonts.inter(
                          color: const Color(0xFF0F1C35),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildCategoryDistributionCard(List<Datum> leads) {
    final productLeads =
        leads.where((lead) => lead.interestedIn == InterestedIn.PRODUCT).length;
    final serviceLeads =
        leads.where((lead) => lead.interestedIn == InterestedIn.SERVICE).length;
    final total = leads.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category Distribution',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F1C35),
            ),
          ),
          const SizedBox(height: 20),
          _buildDistributionItem(
            'Products',
            productLeads,
            total,
            const Color(0xFFBFD633),
          ),
          const SizedBox(height: 12),
          _buildDistributionItem(
            'Services',
            serviceLeads,
            total,
            const Color(0xFF2EC4F3),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionItem(
      String label, int value, int total, Color color) {
    final percentage = total > 0 ? (value / total * 100) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF4A5568),
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: GoogleFonts.inter(
                color: const Color(0xFF0F1C35),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: percentage * 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              color: const Color(0xFF0F1C35),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF404B69),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFilterChip(
      String label, bool isSelected, IconData icon, VoidCallback onTap) {
    return AnimatedScale(
      scale: isSelected ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
              colors: [Color(0xFFBFD633), Color(0xFF2EC4F3)],
            )
                : null,
            color: isSelected ? null : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : const Color(0xFF2EC4F3),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : const Color(0xFF404B69),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M'; // Changed Cr to M for millions
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K'; // Thousands
    } else {
      return amount.toStringAsFixed(0); // No suffix for amounts less than 1000
    }
  }
}