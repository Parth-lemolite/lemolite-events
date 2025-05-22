import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Terms & Conditions Page
class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Terms & Conditions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              children: [
                // Header Card
                _buildHeaderCard(context),
                const SizedBox(height: 20),

                // Content Sections
                _buildContentCard(context),

                // Footer
                const SizedBox(height: 24),
                _buildFooter(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha:0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha:0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'nAIrobi BizTech',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Terms & Conditions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withValues(alpha:0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.schedule,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Last Updated: May 21, 2025',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildIntroSection(context),
          const Divider(height: 1),
          ..._buildAllSections(context),
        ],
      ),
    );
  }

  Widget _buildIntroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Introduction',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome to the nAIrobi App, a platform developed and operated by Lemolite Technologies LLP. By accessing or using our digital services, you agree to comply with and be bound by these Terms.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.8),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer.withValues(alpha:0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.error.withValues(alpha:0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'If you do not agree to these Terms, please do not use the Services.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w500,
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

  List<Widget> _buildAllSections(BuildContext context) {
    final sections = [
      {
        'title': 'Eligibility and User Representations',
        'icon': Icons.person_outline,
        'content': 'By using our Services, you represent and warrant that you are at least 18 years old or have legal authority to act on behalf of a business or legal entity. All information you provide must be truthful, accurate, current, and complete.',
      },
      {
        'title': 'Registration & Information Submission',
        'icon': Icons.app_registration,
        'content': 'Certain features may require submission of personal and business data. You agree to maintain confidentiality of your information, ensure all data submitted is accurate and lawful, and notify us promptly of any unauthorized use.',
      },
      {
        'title': 'Use of the Services',
        'icon': Icons.security,
        'content': 'You agree to use the nAIrobi App and all Services lawfully and ethically. Prohibited activities include misrepresenting your identity, transmitting unlawful content, attempting unauthorized access, and using automated tools without permission.',
      },
      {
        'title': 'Service/Product Inquiries',
        'icon': Icons.help_outline,
        'content': 'When you submit inquiries, you consent to us contacting you via various channels. We may collect business-related data to provide tailored pricing and service details. Incomplete submissions may delay responses.',
      },
      {
        'title': 'Bookings and Transactions',
        'icon': Icons.book_online,
        'content': 'You must review and accept all terms related to specific service providers before confirming bookings. Payment processing is conducted through secure third-party gateways. Bookings are subject to provider acceptance and availability.',
      },
      {
        'title': 'Intellectual Property Rights',
        'icon': Icons.copyright,
        'content': 'All content on nAIrobi App is owned by Lemolite Technologies LLP or its licensors and protected by intellectual property laws. You may not copy, reproduce, distribute, or modify any content without prior written permission.',
      },
      {
        'title': 'Fees, Billing, and Refund Policy',
        'icon': Icons.payment,
        'content': 'All payments are final and non-refundable unless otherwise stated. Server costs are billed separately based on usage. Customization beyond standard scope is billed at \$15 USD per hour with prior approval.',
      },
      {
        'title': 'Data Privacy and Security',
        'icon': Icons.privacy_tip,
        'content': 'Your privacy is important to us. Please review our Privacy Policy. We employ commercially reasonable security measures, but no system is completely secure. You acknowledge the inherent risks of transmitting data online.',
      },
      {
        'title': 'Limitation of Liability',
        'icon': Icons.gavel,
        'content': 'To the maximum extent permitted by law, Lemolite Technologies LLP shall not be liable for any direct, indirect, incidental, or consequential damages. Our total liability is limited to the amount you have paid for access to the relevant Service.',
      },
      {
        'title': 'Governing Law',
        'icon': Icons.location_on,
        'content': 'These Terms are governed by the laws of India. Any disputes shall be subject to the exclusive jurisdiction of the courts located in Ahmedabad, Gujarat, India.',
      },
      {
        'title': 'No Returns Policy',
        'icon': Icons.block_outlined, // or Icons.close_outlined, Icons.disabled_by_default_outlined
        'content': 'All sales made through our platform are final. We do not accept any returns of products or services once a purchase is completed. Please review all information carefully before confirming your order.',
      },
      {
        'title': 'No Refunds Policy',
        'icon': Icons.money_off_outlined, // or Icons.payment_disabled, Icons.block_outlined
        'content': 'We do not offer refunds for any purchases made on our platform. By completing a transaction, you agree to this no-refund policy. If you have any questions before purchasing, please contact our support team.',
      },
      {
        'title': 'No Cancellations Policy',
        'icon': Icons.cancel_outlined, // or Icons.event_busy_outlined, Icons.close_outlined
        'content': 'Orders or subscriptions cannot be cancelled once they are placed. We encourage you to ensure all details are correct prior to confirming your order. Thank you for your understanding.',
      },
    ];

    return sections.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> section = entry.value;

      return _buildSection(
        context,
        section['title'] as String,
        section['content'] as String,
        section['icon'] as IconData,
        index + 1,
        isHighlighted: false,
      );
    }).toList();
  }

  Widget _buildSection(BuildContext context, String title, String content, IconData icon, int number, {bool isHighlighted = false}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(left: 68),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyPoint(BuildContext context, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.error.withValues(alpha:0.8),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.contact_support,
            color: Theme.of(context).colorScheme.primary,
            size: 32,
          ),
          const SizedBox(height: 16),
          Text(
            'Contact Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'If you have questions, concerns, or requests related to these Terms, please contact us:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildContactItem(context, Icons.email, 'sales@lemolite.com'),
          const SizedBox(height: 8),
          _buildContactItem(
            context,
            Icons.location_on,
            '1101, 1103, 1104, Colonnade, Iskcon Cross Road,\nSatellite, Ahmedabad, Gujarat, INDIA - 380059',
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            // padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Card(
              elevation: 8,
              shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha:0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                 color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary.withValues(alpha:0.1),
                              Theme.of(context).colorScheme.secondary.withValues(alpha:0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha:0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withValues(alpha:0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.privacy_tip_rounded,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Privacy Policy',
                                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary.withValues(alpha:0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.secondary.withValues(alpha:0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.update_rounded,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Effective Date: May 21, 2025',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Introduction with highlight
                      _buildHighlightSection(
                        context,
                        'Introduction',
                        'At Nairobi App, your privacy is of utmost importance to us. This Privacy Policy explains how we collect, use, store, and protect your personal information when you interact with our platform—including through our Progressive Web App (PWA), service or product inquiry forms, or engagement with our digital modules. By accessing or using our services, you consent to the practices described in this policy.',
                        Icons.info_outline_rounded,
                      ),

                      _buildSection(
                        context,
                        'Information We Collect',
                        'When you interact with Nairobi App—either by scanning a QR code or visiting our platform directly—we may collect the following information through our landing form:\n\n• Company name\n• Full name\n• Email address\n• Phone number\n• Nature of inquiry (product or service)\n\nFor product-related inquiries, we may also gather details such as your preferred engagement model (e.g., SaaS, reseller, or whitelabel), selected products, and estimated user volume to determine subscription pricing. This information allows us to customize our offerings and ensure effective communication.',
                        Icons.data_usage_rounded,
                      ),

                      _buildSection(
                        context,
                        'How We Use Your Information',
                        'The data you provide enables us to:\n\n• Establish and manage business interactions\n• Offer tailored communication and pricing\n• Facilitate online payments or initiate B2B agreement discussions\n• Share necessary information with our internal sales and service teams\n• Ensure proper follow-up and personalized engagement\n\nAll data usage is aligned with your expressed preferences and business intent.',
                        Icons.settings_applications_rounded,
                      ),

                      _buildSection(
                        context,
                        'Communications and Notifications',
                        'We use your contact information to send essential communications such as:\n\n• Confirmation of form submissions and payments\n• Onboarding guidance\n• Booking confirmations and reminders\n• Agreement-related updates\n\nThese messages are delivered via email, SMS, or in-app notifications to ensure clarity and continuity throughout your interaction.',
                        Icons.notifications_active_rounded,
                      ),

                      _buildSection(
                        context,
                        'User Experience and Personalization',
                        'Our platform is designed for intuitive use. We guide users through features like service setup, availability configuration, and operational preferences using simple prompts and contextual tips. Your usage behavior may be used to personalize dashboards and recommend relevant configurations—ensuring efficiency, usability, and a seamless digital experience.',
                        Icons.person_rounded,
                      ),

                      _buildSection(
                        context,
                        'Booking and Service Management',
                        'For booking-enabled services, we collect only the data required to process appointments and display accurate details such as:\n\n• Service type and pricing\n• Duration\n• Visual assets\n• Real-time availability\n\nThis ensures smooth appointment management and prevents double bookings. Data shared during bookings is used strictly for service fulfillment and relevant communication.',
                        Icons.calendar_today_rounded,
                      ),

                      _buildSection(
                        context,
                        'Data Sharing and Third Parties',
                        'We do not sell or rent your personal data. However, we may work with trusted third-party service providers—such as payment gateways or hosting partners—to operate certain functionalities. These providers are bound by data protection agreements and only access the information needed to perform their services securely and lawfully.',
                        Icons.share_rounded,
                      ),

                      _buildImportantSection(
                        context,
                        'Data Security and Protection',
                        'We use industry-standard security practices to protect your data:\n\n• Encryption for data transmission and storage\n• Controlled access protocols\n• Regular security audits and software updates\n\nIn the event of a security incident, we act swiftly to mitigate risks and notify affected users if required.',
                        Icons.security_rounded,
                      ),

                      _buildSection(
                        context,
                        'Data Retention and Deletion',
                        'We retain your personal data only for as long as needed to fulfill the purposes outlined here. Information related to transactions may be stored for compliance or regulatory requirements. You may request deletion of your data, except where legal or contractual obligations require us to retain it.',
                        Icons.delete_forever_rounded,
                      ),

                      _buildImportantSection(
                        context,
                        'Your Data Protection Rights',
                        'You have the right to:\n\n• Access a summary of your personal data\n• Opt out of non-essential communications\n• Request the deletion or restriction of your data usage\n\nTo exercise these rights, contact us at: sales@lemolite.com\n\nTransactional and security communications may still be sent when necessary.',
                        Icons.gavel_rounded,
                      ),

                      _buildSection(
                        context,
                        'International Data Transfers',
                        'As we operate using global cloud infrastructure, your data may be processed in countries outside your own. We ensure all cross-border data transfers meet legal safeguards and offer adequate protection under applicable data privacy laws.',
                        Icons.public_rounded,
                      ),

                      _buildSection(
                        context,
                        'Children\'s Privacy',
                        'Our application is not intended for use by children under the age of 13. We do not knowingly collect personally identifiable information from children under 13. If you are a parent or guardian and you are aware that your child has provided us with Personal Data, please contact us.',
                        Icons.child_care_rounded,
                      ),

                      _buildSection(
                        context,
                        'Changes to This Privacy Policy',
                        'We may update this Privacy Policy from time to time to reflect changes in our services, technology, or legal requirements. Updated versions will be published with a revised effective date. We encourage you to review the policy periodically.',
                        Icons.update_rounded,
                      ),

                      // Contact Section with enhanced styling
                      _buildContactSection(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha:0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha:0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightSection(BuildContext context, String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha:0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha:0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantSection(BuildContext context, String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary.withValues(alpha:0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary.withValues(alpha:0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
       color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha:0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha:0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.contact_support_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Contact Us',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'For any questions or concerns regarding this Privacy Policy or your data, please contact our Privacy Team at:',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.8),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha:0.08),
                  Theme.of(context).colorScheme.secondary.withValues(alpha:0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha:0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.email_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Email: ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'sales@lemolite.com',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Address: ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '1101, 1103, 1104, Colonnade, Iskcon Cross Road, Satellite, Ahmedabad, Gujarat, INDIA - 380059',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// Shipping Policy Page
class ShippingPolicyPage extends StatelessWidget {
  const ShippingPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Shipping Terms',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withValues(alpha:0.1),
                    Theme.of(context).colorScheme.tertiary.withValues(alpha:0.05),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Virtual Content Delivery',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Effective: May 21, 2025',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'These terms govern the virtual delivery of digital content through the Nairobi App, operated by Lemolite Technologies LLP.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Content Sections
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildExpandableSection(
                    context,
                    Icons.cloud_download_outlined,
                    'Virtual Delivery Scope',
                    'Our platform provides digital transmission tools for various content types including downloadable files, streaming media, software licenses, and SaaS modules.',
                    _buildDeliveryDetails(context),
                  ),
                  const SizedBox(height: 16),

                  _buildExpandableSection(
                    context,
                    Icons.verified_user_outlined,
                    'Your Responsibilities',
                    'As a content provider, you must ensure ownership rights, legal compliance, and content appropriateness.',
                    _buildResponsibilitiesDetails(context),
                  ),
                  const SizedBox(height: 16),

                  _buildExpandableSection(
                    context,
                    Icons.warning_amber_outlined,
                    'Service Limitations',
                    'Virtual delivery may be affected by factors beyond our control. Understanding these limitations is important.',
                    _buildLimitationsDetails(context),
                  ),
                  const SizedBox(height: 16),

                  _buildExpandableSection(
                    context,
                    Icons.security_outlined,
                    'Data Security & Privacy',
                    'We implement industry-standard security measures including end-to-end encryption and secure storage.',
                    _buildSecurityDetails(context),
                  ),
                  const SizedBox(height: 16),

                  _buildExpandableSection(
                    context,
                    Icons.copyright_outlined,
                    'Intellectual Property',
                    'Your content ownership rights remain with you. We only process content for delivery purposes.',
                    _buildIPDetails(context),
                  ),
                  const SizedBox(height: 16),

                  _buildExpandableSection(
                    context,
                    Icons.settings_outlined,
                    'Service Modifications',
                    'We reserve the right to modify or terminate services for policy violations, security risks, or legal requirements.',
                    _buildModificationsDetails(context),
                  ),
                ],
              ),
            ),

            // Contact Section
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withValues(alpha:0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha:0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.support_agent,
                    size: 32,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Need Help?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Contact our support team for delivery issues or security incidents',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary.withValues(alpha:0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildContactButton(
                        context,
                        Icons.email_outlined,
                        'Email Support',
                        'sales@lemolite.com',
                      ),
                      _buildContactButton(
                        context,
                        Icons.location_on_outlined,
                        'Visit Office',
                        'Ahmedabad, Gujarat',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection(
      BuildContext context,
      IconData icon,
      String title,
      String summary,
      Widget details,
      ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              summary,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: details,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Methods Include:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...[
          'Direct download links via email or in-app',
          'User dashboard access to virtual assets',
          'Embedded integration within external platforms',
          'Automated notifications with access details',
        ].map((item) => _buildBulletPoint(context, item)),
        const SizedBox(height: 16),
        _buildInfoBox(
          context,
          'Configuration Required',
          'You must provide accurate recipient details, access credentials, and delivery timelines.',
          Icons.settings_outlined,
        ),
      ],
    );
  }

  Widget _buildResponsibilitiesDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildResponsibilityCard(context, 'Ownership & Rights', 'Hold necessary rights and licenses for content distribution'),
        _buildResponsibilityCard(context, 'Legal Compliance', 'Ensure content complies with all applicable laws and regulations'),
        _buildResponsibilityCard(context, 'Content Appropriateness', 'Content must be legal, appropriate, and non-infringing'),
        const SizedBox(height: 12),
        _buildWarningBox(
          context,
          'You remain solely responsible for content legality, audience targeting, and handling recipient disputes.',
        ),
      ],
    );
  }

  Widget _buildLimitationsDetails(BuildContext context) {
    return Column(
      children: [
        _buildLimitationCard(context, 'No Delivery Guarantee', 'We cannot guarantee uninterrupted or error-free delivery'),
        _buildLimitationCard(context, 'Third-party Dependencies', 'Delivery affected by spam filters and network delays'),
        _buildLimitationCard(context, 'Recipient Data Accuracy', 'Incorrect recipient information is your responsibility'),
        _buildLimitationCard(context, 'Technical Issues', 'Not liable for recipient-side technical problems'),
        const SizedBox(height: 12),
        _buildWarningBox(
          context,
          'Our liability is limited to the fullest extent permitted by law.',
        ),
      ],
    );
  }

  Widget _buildSecurityDetails(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.lock_outlined, color: Colors.green[600], size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text('End-to-end encryption during transmission', style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.storage_outlined, color: Colors.green[600], size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text('Secure storage with role-based access', style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.monitor_heart_outlined, color: Colors.green[600], size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text('Regular monitoring and security audits', style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ),
        const SizedBox(height: 12),
        _buildWarningBox(context, 'No system is 100% secure. You must maintain credential confidentiality.'),
      ],
    );
  }

  Widget _buildIPDetails(BuildContext context) {
    return _buildInfoBox(
      context,
      'Your Rights Protected',
      'All content rights remain yours. We only receive limited license for delivery purposes and claim no ownership over your intellectual property.',
      Icons.verified_outlined,
    );
  }

  Widget _buildModificationsDetails(BuildContext context) {
    return Column(
      children: [
        _buildInfoBox(
          context,
          'Service Changes',
          'We may modify services for policy violations, security risks, or legal requirements. Users will be notified through reasonable channels.',
          Icons.info_outlined,
        ),
        const SizedBox(height: 12),
        _buildInfoBox(
          context,
          'Policy Updates',
          'This policy may be updated periodically. Check regularly for changes with revised effective dates.',
          Icons.update_outlined,
        ),
      ],
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 8),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsibilityCard(BuildContext context, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLimitationCard(BuildContext context, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange[700], size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[800],
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context, String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha:0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBox(BuildContext context, String content) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined, color: Colors.red[700], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(BuildContext context, IconData icon, String label, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary.withValues(alpha:0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary.withValues(alpha:0.8),
          ),
        ),
      ],
    );
  }
}