import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/app_controller.dart';
import '../widgets/contact_form.dart';

class ContactDetailsStep extends StatelessWidget {
  const ContactDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    return Form(
      key: controller.contactFormKey, // Changed: Use contactFormKey
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Review and update your details.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          ContactForm(
            formKey: controller.contactFormKey,
            nameController: controller.nameController,
            emailController: controller.emailController,
            companyController: controller.companyController,
            phoneController: controller.phoneController,
            messageController: controller.messageController,
            messageLabel: 'Additional Comments',
            messagePlaceholder:
            'Share any specific requirements or questions...',
          ),
        ],
      ),
    );
  }
}
