import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Full Terms & Conditions text for copying
    const String fullTermsConditions = '''
Terms & Conditions
Effective Date: 21 May 2025

Welcome to the nAIrobi App, a platform developed and operated by Lemolite Technologies LLP (“we,” “us,” or “our”). These Terms & Conditions (“Terms”) govern your use of our digital services—including the Progressive Web App (PWA), service/product inquiries, booking features, SaaS modules, and all related functionalities (collectively, the “Services”).
By accessing or using the nAIrobi App or any of its Services, you agree to comply with and be bound by these Terms. If you do not agree to these Terms, please do not use the Services.

1. Eligibility and User Representations
By using our Services, you represent and warrant that:
- You are at least 18 years old or have legal authority to act on behalf of a business or legal entity.
- All information you provide to us is truthful, accurate, current, and complete.
- You will update your information as necessary to keep it current.
- Your use of our Services complies with all applicable laws and regulations.
Failure to meet these criteria may result in suspension or termination of access.

2. Registration & Information Submission
Certain features—such as bookings, dashboards, or SaaS tools—may require submission of personal and business data, even if traditional account creation is not mandatory.
By submitting such data, you agree that:
- Maintaining the confidentiality of your information.
- Ensuring all data submitted is accurate and lawful.
- Notifying us promptly of any unauthorized use or security breaches related to your provided information.
You agree that we may use your data to facilitate your use of the Services, communicate important information, and personalize your experience.

3. Use of the Services
You agree to use the nAIrobi App and all Services lawfully and ethically. Prohibited activities include, but are not limited to:
- Misrepresenting your identity or affiliation.
- Using the platform to transmit unlawful, harmful, or offensive content.
- Attempting to gain unauthorized access to our systems or other users’ data.
- Engaging in activities that interfere with or disrupt the platform’s operation.
- Using automated tools to scrape data or harvest information without permission.
We reserve the right to monitor and investigate suspected violations and to suspend or terminate access when these Terms are breached.

4. Service/Product Inquiries and Engagements
When you submit inquiries or request product/service information:
- You consent to us contacting you via phone, email, or other communication channels regarding your inquiry.
- We may collect and process data related to your business type, engagement model (e.g., SaaS, reseller), and user volume to provide tailored pricing and service details.
- Incomplete or inaccurate submissions may delay responses or lead to rejection of your inquiry.
We reserve the right to refuse engagement if the inquiry is fraudulent, unlawful, or outside our scope of services.

5. Bookings and Transactions
For users utilizing booking services through the platform:
- You must carefully review and accept all terms related to the specific service provider, including pricing, availability, duration, cancellation policies, and any fees before confirming a booking.
- Payment processing, where applicable, will be conducted through secure third-party gateways; nAIrobi App does not store payment card information directly.
- Confirmed bookings are subject to provider acceptance and availability.
- Cancellations, and modifications, requests are subject to the provider’s policies, which will be clearly presented prior to booking confirmation.
You agree to comply with all terms set by the service providers you engage with via our platform.

6. Intellectual Property Rights
All content on nAIrobi App—including but not limited to text, graphics, logos, icons, images, software, and trademarks—is owned by Lemolite Technologies LLP or its licensors and protected by intellectual property laws.
You may not:
- Copy, reproduce, distribute, modify, or create derivative works from any content without prior written permission.
- Use any trademarks or service marks displayed on the platform without authorization.
Use of the platform grants no ownership or license rights to you except for the limited right to access and use the Services as permitted under these Terms.

7. Fees, Billing, and Refund Policy
- Non-Refundable Fees: Due to the digital and consultative nature of our offerings, all payments are final and non-refundable, unless otherwise stated in a written agreement.
- Server Costs: Server infrastructure and hosting fees are not included in standard pricing and will be billed separately based on your usage and storage requirements.
- Customization Charges: Any customization beyond the standard scope will be billed at \$15 USD per hour, with prior approval and estimates shared beforehand.

8. Post-Delivery Revisions & Change Requests
We offer a two (2) week revision window post-delivery to accommodate minor adjustments at no extra cost.
Any requests made after this period or that require more than 2–4 hours of effort will be considered a Change Request (CR) and billed separately as per our standard hourly rates.

9. Third-Party Integrations
We may integrate third-party services (e.g., payment gateways, analytics, CRM tools) to enhance platform functionality.
Lemolite Technologies LLP is not responsible for the performance, reliability, or availability of any third-party services integrated into your solution.
Continued support for third-party features is subject to the respective provider’s policies and stability.

10. Data Privacy and Security
Your privacy is important to us. Please review our Privacy Policy, which explains how we collect, use, and protect your personal data. By using nAIrobi App, you consent to data collection and processing as described in our Privacy Policy.
We employ commercially reasonable security measures such as encryption, access controls, and monitoring to protect your information, but no system is completely secure. You acknowledge and accept the inherent risks of transmitting data online.

11. Limitation of Liability
To the maximum extent permitted by law, Lemolite Technologies LLP and its affiliates shall not be liable for any:
- Direct, indirect, incidental, consequential, special, or punitive damages.
- Loss of profits, data, goodwill, or other intangible losses.
- Errors, inaccuracies, or interruptions in the Services.
- Unauthorized access to or alteration of your data.
Our total liability for any claim arising from your use of the Services is limited to the amount you have paid, if any, for access to the relevant Service.

12. Indemnification
You agree to indemnify, defend, and hold harmless Lemolite Technologies LLP, its officers, employees, and affiliates from and against any claims, liabilities, damages, losses, or expenses (including reasonable attorneys’ fees) arising from:
- Your violation of these Terms
- Your misuse of the platform or Services
- Your breach of any applicable laws or third-party rights

13. Termination and Suspension
We may, at our sole discretion, suspend or terminate your access to the Services without prior notice or liability if you:
- Violate these Terms
- Engage in fraudulent, abusive, or unlawful conduct
- Pose security risks to other users or the platform
Upon termination, your rights to use the Services immediately cease. Sections relating to intellectual property, liability, indemnification, and governing law will survive termination.

14. Changes to Terms
We reserve the right to modify or update these Terms at any time. When changes occur, the updated Terms will be posted with a new effective date. Your continued use of nAIrobi App after such changes constitutes acceptance of the revised Terms.
We recommend that you review these Terms periodically to stay informed.

15. Governing Law and Dispute Resolution
These Terms are governed by the laws of India, without regard to conflict of law principles.
Any disputes arising out of or relating to these Terms or your use of nAIrobi App shall be subject to the exclusive jurisdiction of the courts located in Ahmedabad, Gujarat, India.

16. Contact Information
If you have questions, concerns, or requests related to these Terms or the nAIrobi App, please contact us:
Email: sales@lemolite.com
Address: 1101, 1103, 1104, Colonnade, Iskcon Cross Road, Satellite, Ahmedabad, Gujarat, INDIA - 380059
''';

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
        decoration: const BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              children: [
                // Selectable Terms & Conditions Text for Copying
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SelectableText.rich(
                        TextSpan(
                          children: _buildTextSpans(context, fullTermsConditions),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to build TextSpans with tappable email
  List<TextSpan> _buildTextSpans(BuildContext context, String text) {
    const String email = 'sales@lemolite.com';
    List<TextSpan> spans = [];
    int index = 0;

    while (index < text.length) {
      int emailIndex = text.indexOf(email, index);

      if (emailIndex == -1) {
        // No more email occurrences, add the rest of the text
        spans.add(TextSpan(text: text.substring(index)));
        break;
      }

      // Add text before the email
      if (emailIndex > index) {
        spans.add(TextSpan(text: text.substring(index, emailIndex)));
      }

      // Add the email as a tappable link
      spans.add(
        TextSpan(
          text: email,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: email,
              );
              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch email client')),
                );
              }
            },
        ),
      );

      index = emailIndex + email.length;
    }

    return spans;
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Full Privacy Policy text for copying
    const String fullPrivacyPolicy = '''
Privacy Policy
Effective Date: 21-May-2025

At Nairobi App, your privacy is of utmost importance to us. This Privacy Policy explains how we collect, use, store, and protect your personal information when you interact with our platform—including through our Progressive Web App (PWA), service or product inquiry forms, or engagement with our digital modules. By accessing or using our services, you consent to the practices described in this policy.

1. Information We Collect
When you interact with Nairobi App—either by scanning a QR code or visiting our platform directly—we may collect the following information through our landing form:
- Company name
- Full name
- Email address
- Phone number
- Nature of inquiry (product or service)
For product-related inquiries, we may also gather details such as your preferred engagement model (e.g., SaaS, reseller, or whitelabel), selected products, and estimated user volume to determine subscription pricing. This information allows us to customize our offerings and ensure effective communication.

2. How We Use Your Information
The data you provide enables us to:
- Establish and manage business interactions
- Offer tailored communication and pricing
- Facilitate online payments or initiate B2B agreement discussions
- Share necessary information with our internal sales and service teams
- Ensure proper follow-up and personalized engagement
All data usage is aligned with your expressed preferences and business intent.

3. Communications and Notifications
We use your contact information to send essential communications such as:
- Confirmation of form submissions and payments
- Onboarding guidance
- Booking confirmations and reminders
- Agreement-related updates
These messages are delivered via email, SMS, or in-app notifications to ensure clarity and continuity throughout your interaction.

4. User Experience and Personalization
Our platform is designed for intuitive use. We guide users through features like service setup, availability configuration, and operational preferences using simple prompts and contextual tips. Your usage behavior may be used to personalize dashboards and recommend relevant configurations—ensuring efficiency, usability, and a seamless digital experience.

5. Booking and Service Management
For booking-enabled services, we collect only the data required to process appointments and display accurate details such as:
- Service type and pricing
- Duration
- Visual assets
- Real-time availability
This ensures smooth appointment management and prevents double bookings. Data shared during bookings is used strictly for service fulfillment and relevant communication. Cancellation and refund policies are clearly displayed and must be acknowledged before completing a booking.

6. Data Sharing and Third Parties
We do not sell or rent your personal data. However, we may work with trusted third-party service providers—such as payment gateways or hosting partners—to operate certain functionalities. These providers are bound by data protection agreements and only access the information needed to perform their services securely and lawfully.

7. Data Security and Protection
We use industry-standard security practices to protect your data:
- Encryption for data transmission and storage
- Controlled access protocols
- Regular security audits and software updates
In the event of a security incident, we act swiftly to mitigate risks and notify affected users if required.

8. Data Retention and Deletion
We retain your personal data only for as long as needed to fulfill the purposes outlined here. Information related to transactions may be stored for compliance or regulatory requirements. You may request deletion of your data, except where legal or contractual obligations require us to retain it.

9. User Rights and Choices
You have the right to:
- Access a summary of your personal data
- Opt out of non-essential communications
- Request the deletion or restriction of your data usage
To exercise these rights, contact us at: sales@lemolite.com
Transactional and security communications may still be sent when necessary.

10. International Data Transfers
As we operate using global cloud infrastructure, your data may be processed in countries outside your own. We ensure all cross-border data transfers meet legal safeguards and offer adequate protection under applicable data privacy laws.

11. Changes to This Privacy Policy
We may update this Privacy Policy from time to time to reflect changes in our services, technology, or legal requirements. Updated versions will be published with a revised effective date. We encourage you to review the policy periodically.

12. Contact Us
For any questions or concerns regarding this Privacy Policy or your data, please contact our Privacy Team at:
Email: sales@lemolite.com
Address: 1101, 1103, 1104, Colonnade, Iskcon Cross Road, Satellite, Ahmedabad, Gujarat, INDIA - 380059
''';

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
            child: Card(
              elevation: 8,
              shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
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
                  // Selectable Privacy Policy Text with Tappable Email
                  Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SelectableText.rich(
                         TextSpan(
                          children: _buildTextSpans(context, fullPrivacyPolicy),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Add other sections here if needed
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

  // Function to build TextSpans with tappable email
  List<TextSpan> _buildTextSpans(BuildContext context, String text) {
    const String email = 'sales@lemolite.com';
    List<TextSpan> spans = [];
    int index = 0;

    while (index < text.length) {
      int emailIndex = text.indexOf(email, index);

      if (emailIndex == -1) {
        // No more email occurrences, add the rest of the text
        spans.add(TextSpan(text: text.substring(index)));
        break;
      }

      // Add text before the email
      if (emailIndex > index) {
        spans.add(TextSpan(text: text.substring(index, emailIndex)));
      }

      // Add the email as a tappable link
      spans.add(
        TextSpan(
          text: email,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: email,
              );
              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch email client')),
                );
              }
            },
        ),
      );

      index = emailIndex + email.length;
    }

    return spans;
  }
}

class ShippingPolicyPage extends StatelessWidget {
  const ShippingPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Full Shipping Terms content for copying
    const String fullShippingTerms = '''
Shipping Terms – Virtual Content Delivery
Effective Date: 21-May-2025

These terms govern the virtual delivery of digital content facilitated through the Nairobi App, operated by Lemolite Technologies LLP. By accessing and using our platform for delivering digital goods or services, you acknowledge and accept the terms outlined below.

1. Scope of Virtual Delivery
The Nairobi App provides tools and infrastructure for the digital transmission or "shipping" of virtual content. This includes, but is not limited to:
- Downloadable digital files (e.g., PDFs, ZIPs, images)
- Streaming media (audio, video)
- Software access credentials or licenses
- Embedded content or code snippets
- SaaS-based modules or dashboard features
Delivery Mechanisms May Include:
- Direct download links shared via email or in-app
- User dashboard access to virtual assets
- Embedded integration within external platforms
- Automated notifications with instructions and content access details
You are responsible for configuring accurate delivery parameters, such as:
- Recipient email addresses or user IDs
- Access credentials and permissions
- Delivery timelines or content expiration settings

2. Your Responsibilities as the Content Provider
By using our platform to deliver virtual content, you represent and warrant that:
- Ownership & Rights: You hold the necessary rights, licenses, or authorizations to distribute the content.
- Compliance: Your content complies with all applicable laws and regulations, including data protection, intellectual property, and digital content distribution laws.
- Appropriateness: The content must not include any illegal, harmful, offensive, misleading, or infringing material.
You are solely responsible for the:
- Legality and validity of the content
- Intended use and audience targeting
- Handling of recipient queries, complaints, or disputes
Lemolite Technologies LLP assumes no liability for the content’s substance or consequences resulting from its distribution.

3. Limitations of Virtual Delivery Services
While we strive for efficiency and reliability, virtual content delivery may be impacted by factors beyond our control. Please note:
- No Guarantee of Delivery: We do not guarantee uninterrupted, real-time, or error-free delivery.
- Third-party Dependencies: Delivery can be affected by spam filters, external platform restrictions, or network delays.
- Incorrect Recipient Info: Delivery issues due to inaccurate or incomplete recipient data provided by you are not our responsibility.
- Recipient-Side Errors: We are not liable for recipient-side technical issues such as expired links, device incompatibility, or blocked content.
- Limitation of Liability: Our responsibility for failed or delayed delivery is strictly limited to the fullest extent permitted by law and does not extend to consequential damages or loss of business opportunities.

4. Data Handling, Security & Confidentiality
We take reasonable steps to safeguard your digital content and delivery data in line with industry standards and our Privacy Policy. Measures include:
- End-to-end encryption during data transmission
- Secure storage and role-based access controls
- Regular system monitoring and risk audits
However:
- No system is 100% secure. You acknowledge the inherent risks of digital data transmission.
- You are responsible for maintaining the confidentiality of login credentials, access links, and sensitive delivery content.
- Lemolite is not responsible for unauthorized access resulting from user-side negligence or credential misuse.

5. Intellectual Property and Content Ownership
All rights to your virtual content remain with you.
By using our platform, you grant Lemolite a limited license to host, process, and deliver the content solely for the intended delivery purpose.
We do not claim ownership over your intellectual property.

6. Service Modifications & Termination
We reserve the right to modify, suspend, or terminate any delivery service features at our discretion, especially in the event of:
- Policy violations
- Technical or security risks
- Legal obligations or platform changes
In such cases, users will be informed through reasonable channels and allowed to retrieve their virtual assets, if applicable.

7. Changes to This Shipping Policy
We may update this Shipping Policy from time to time to reflect changes in our services, technology, or legal requirements. Updated versions will be published with a revised effective date. We encourage you to review the policy periodically.

8. Contact Us
For assistance related to digital delivery, access issues, or data security incidents, please reach out to our support team:
Email: sales@lemolite.com
Address: 1101, 1103, 1104, Colonnade, Iskcon Cross Road, Satellite, Ahmedabad, Gujarat, INDIA - 380059
''';

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
            // Selectable Shipping Terms Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText.rich(
                    TextSpan(
                      children: _buildTextSpans(context, fullShippingTerms),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                      ),
                    ),
                  )

                ],
              ),
            ),
            // Header Section

          ],
        ),
      ),
    );
  }

  // Function to build TextSpans with tappable email
  List<TextSpan> _buildTextSpans(BuildContext context, String text) {
    const String email = 'sales@lemolite.com';
    List<TextSpan> spans = [];
    int index = 0;

    while (index < text.length) {
      int emailIndex = text.indexOf(email, index);

      if (emailIndex == -1) {
        // No more email occurrences, add the rest of the text
        spans.add(TextSpan(text: text.substring(index)));
        break;
      }

      // Add text before the email
      if (emailIndex > index) {
        spans.add(TextSpan(text: text.substring(index, emailIndex)));
      }

      // Add the email as a tappable link
      spans.add(
        TextSpan(
          text: email,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: email,
              );
              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch email client')),
                );
              }
            },
        ),
      );

      index = emailIndex + email.length;
    }

    return spans;
  }
}
