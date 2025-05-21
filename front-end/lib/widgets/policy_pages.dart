import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

// Terms & Conditions Page
class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terms & Conditions',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Last Updated: May 21, 2025',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      context,
                      'Introduction',
                      'Welcome to n"AI"robi BizTech ("we," "our," or "us"). By accessing or using our application, you agree to be bound by these Terms and Conditions. If you disagree with any part of these terms, you may not access our service.',
                    ),
                    _buildSection(
                      context,
                      'Use License',
                      'Permission is granted to temporarily download one copy of the materials on our application for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:\n\n• Modify or copy the materials\n• Use the materials for any commercial purpose or for any public display\n• Attempt to reverse engineer any software contained on our application\n• Remove any copyright or other proprietary notations from the materials\n• Transfer the materials to another person or "mirror" the materials on any other server.',
                    ),
                    _buildSection(
                      context,
                      'User Account',
                      'To access certain features of our application, you may be required to create an account. You are responsible for maintaining the confidentiality of your account information and for all activities under your account. You agree to notify us immediately of any unauthorized use of your account.',
                    ),
                    _buildSection(
                      context,
                      'Service Changes',
                      'We reserve the right to withdraw or amend our service, and any service or material we provide, in our sole discretion without notice. We will not be liable if, for any reason, all or any part of our service is unavailable at any time or for any period.',
                    ),
                    _buildSection(
                        context,
                        'Prohibited Uses',
                        'You may use our application only for lawful purposes and in accordance with these Terms. You agree not to use our application:\n\n• In any way that violates any applicable federal, state, local, or international law or regulation\n• To transmit, or procure the sending of, any advertising or promotional material, including any "junk mail," "chain letter," "spam," or any other similar solicitation\n• To impersonate or attempt to impersonate us, our employees, another user, or any other person or entity\n• To engage in any other conduct that restricts or inhibits anyones use or enjoyment of our application.',
                    ),
                    _buildSection(
                      context,
                      'Intellectual Property',
                      'Our application and its entire contents, features, and functionality (including but not limited to all information, software, text, displays, images, video, and audio, and the design, selection, and arrangement thereof) are owned by us, our licensors, or other providers of such material and are protected by copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.',
                    ),
                    _buildSection(
                      context,
                      'Limitation of Liability',
                      'In no event will we, our affiliates, or their licensors, service providers, employees, agents, officers, or directors be liable for damages of any kind, under any legal theory, arising out of or in connection with your use, or inability to use, our application, any websites linked to it, any content on our application or such other websites, including any direct, indirect, special, incidental, consequential, or punitive damages.',
                    ),
                    _buildSection(
                      context,
                      'Governing Law',
                      'These Terms and Conditions shall be governed by and construed in accordance with the laws of [Your Country/State], without regard to its conflict of law provisions. Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights.',
                    ),
                    _buildSection(
                      context,
                      'Changes to Terms',
                      'We may revise these Terms and Conditions at any time without notice. By using our application, you are agreeing to be bound by the then-current version of these Terms and Conditions.',
                    ),
                    _buildSection(
                      context,
                      'Contact Us',
                      'If you have any questions about these Terms, please contact us at sales@lemolite.com.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

// Privacy Policy Page
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Privacy Policy',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Last Updated: May 21, 2025',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      context,
                      'Introduction',
                      'n"AI"robi BizTech ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our application. Please read this Privacy Policy carefully. By accessing or using our application, you agree to this Privacy Policy.',
                    ),
                    _buildSection(
                        context,
                        'Information We Collect',
                        'We may collect information about you in various ways, including:\n\n• Personal Data: While using our application, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you ("Personal Data"). Personal Data may include, but is not limited to, your name, email address, phone number, and postal address.\n\n• Usage Data: We may also collect information on how the application is accessed and used ("Usage Data"). This may include information such as your devics Internet Protocol address, browser type, browser version, pages of our application that you visit, the time and date of your visit, the time spent on those pages, and other diagnostic data.',
                    ),
                    _buildSection(
                      context,
                      'How We Use Your Information',
                      'We may use the information we collect about you for various purposes, including to:\n\n• Provide and maintain our application\n• Notify you about changes to our application\n• Allow you to participate in interactive features of our application when you choose to do so\n• Provide customer support\n• Gather analysis or valuable information so that we can improve our application\n• Monitor the usage of our application\n• Detect, prevent and address technical issues\n• Provide you with news, special offers, and general information about other goods, services, and events which we offer.',
                    ),
                    _buildSection(
                      context,
                      'Data Security',
                      'The security of your data is important to us, but remember that no method of transmission over the Internet or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data, we cannot guarantee its absolute security.',
                    ),
                    _buildSection(
                      context,
                      'Data Retention',
                      'We will retain your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use your Personal Data to the extent necessary to comply with our legal obligations, resolve disputes, and enforce our legal agreements and policies.',
                    ),
                    _buildSection(
                      context,
                      'Disclosure of Data',
                      'We may disclose your Personal Data in the good faith belief that such action is necessary to:\n\n• Comply with a legal obligation\n• Protect and defend the rights or property of our company\n• Prevent or investigate possible wrongdoing in connection with the application\n• Protect the personal safety of users of the application or the public\n• Protect against legal liability.',
                    ),
                    _buildSection(
                      context,
                      'Your Data Protection Rights',
                      'You have certain data protection rights. If you wish to be informed about what Personal Data we hold about you and if you want it to be removed from our systems, please contact us. In certain circumstances, you have the following data protection rights:\n\n• The right to access, update or delete the information we have on you\n• The right of rectification\n• The right to object\n• The right of restriction\n• The right to data portability\n• The right to withdraw consent.',
                    ),
                    _buildSection(
                      context,
                      'Children\'s Privacy',
                      'Our application is not intended for use by children under the age of 13. We do not knowingly collect personally identifiable information from children under 13. If you are a parent or guardian and you are aware that your child has provided us with Personal Data, please contact us.',
                    ),
                    _buildSection(
                      context,
                      'Changes to This Privacy Policy',
                      'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date at the top of this Privacy Policy. You are advised to review this Privacy Policy periodically for any changes.',
                    ),
                    _buildSection(
                      context,
                      'Contact Us',
                      'If you have any questions about this Privacy Policy, please contact us at sales@lemolite.com.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

// Shipping Policy Page
class ShippingPolicyPage extends StatelessWidget {
  const ShippingPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Shipping Policy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shipping Policy',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Last Updated: May 21, 2025',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      context,
                      'Order Processing',
                      'We aim to process all orders within 1-2 business days of receiving them. During peak seasons or promotional periods, processing times may be extended by an additional 1-3 business days. You will receive a confirmation email once your order has been processed and is ready for shipping.',
                    ),
                    _buildSection(
                      context,
                      'Shipping Methods & Timeframes',
                      'We offer the following shipping options:\n\n• Standard Shipping: 3-5 business days (Local)\n• Standard International Shipping: 7-14 business days\n• Express Shipping: 1-3 business days (Local)\n• Express International Shipping: 3-7 business days\n\nPlease note that these timeframes are estimates and not guarantees. Shipping times may vary based on your location, customs clearance processes, and other external factors.',
                    ),
                    _buildSection(
                      context,
                      'Shipping Rates',
                      'Shipping rates are calculated based on the weight, dimensions, destination of your order, and the shipping method you select. You can view the exact shipping cost during the checkout process before completing your order.\n\nWe offer free standard shipping on all orders above [Amount] within [Country/Region]. This offer is subject to change and may not be available during certain promotional periods.',
                    ),
                    _buildSection(
                      context,
                      'Tracking Your Order',
                      'Once your order has been shipped, you will receive a tracking number via email. You can use this tracking number to monitor the progress of your delivery through our application or directly through the carrier\'s website. Please allow up to 24 hours after receiving your shipping confirmation for the tracking information to become active.',
                    ),
                    _buildSection(
                      context,
                      'International Shipping',
                      'For international orders, please note that:\n\n• The recipient is responsible for all applicable customs duties, taxes, and fees.\n• We are not responsible for any delays, confiscations, or additional charges imposed by customs authorities.\n• Delivery times may be longer than estimated due to customs processing.\n• Please ensure your shipping address is complete and accurate to avoid delivery issues.',
                    ),
                    _buildSection(
                      context,
                      'Order Changes & Cancellations',
                      'If you need to make changes to your order or shipping address, please contact our customer service team immediately atsales@lemolite.com. We will try our best to accommodate your request, but once an order has been processed or shipped, we may not be able to make changes.\n\nOrders can be cancelled within 2 hours of placement. After this time, we cannot guarantee cancellation as your order may already be in the processing stage.',
                    ),
                    _buildSection(
                      context,
                      'Shipping Restrictions',
                      'We currently do not ship to the following countries: [List of countries if applicable].\n\nCertain products may have shipping restrictions due to their nature or local regulations. If a product cannot be shipped to your location, this will be indicated during the checkout process.',
                    ),
                    _buildSection(
                      context,
                      'Lost or Damaged Packages',
                      'If your package is reported as delivered but you have not received it, please contact our customer service team within 5 days of the reported delivery date. For visibly damaged packages, please refuse delivery if possible and contact us immediately. If you discover damaged items after accepting delivery, please take photos of the damaged items and packaging, and contact us within 48 hours of delivery.',
                    ),
                    _buildSection(
                      context,
                      'Contact Us',
                      'If you have any questions about our shipping policy or need assistance with a shipment, please contact our customer service team atsales@lemolite.com or call us at +91 9313834815.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
