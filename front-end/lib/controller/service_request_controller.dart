import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_controller.dart';

class ServiceRequestController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();
  final contactFormKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  String? selectedService;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    companyController.dispose();
    phoneController.dispose();
    messageController.dispose();
    super.onClose();
  }

  Future<void> submitForm(BuildContext context) async {
    if (contactFormKey.currentState != null &&
        contactFormKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        await sendEmails();
        Get.find<AppController>().isSubmitted.value = true;
        debugPrint('Service flow submitted');
      } catch (e) {
        hasError.value = true;
        debugPrint('Submission error: $e');
        Get.snackbar(
          'Error',
          'An error occurred. Please try again.',
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          margin: const EdgeInsets.all(16),
          borderRadius: 10,
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'Please fill all required fields correctly',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> sendEmails() async {
    final String referenceNumber =
        'LL${DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13)}';
    final Map<String, dynamic> formData = {
      'flow': 'Service Request',
      'name': nameController.text,
      'email': emailController.text,
      'company': companyController.text,
      'phone': phoneController.text,
      'message': messageController.text,
      'serviceType': selectedService,
      'referenceNumber': referenceNumber,
      'timestamp': DateTime.now().toIso8601String(),
    };

    final internalEmail = {
      'to': 'sales@lemolite.com',
      'subject': 'Service Request Submission - $referenceNumber',
      'body': '''
New Service Request Submission
Reference: $referenceNumber
Name: ${formData['name']}
Email: ${formData['email']}
Company: ${formData['company']}
Phone: ${formData['phone']}
Service Type: ${formData['serviceType']}
Message: ${formData['message']}
Submitted: ${formData['timestamp']}
      ''',
    };

    final userEmail = {
      'to': formData['email'],
      'subject': 'nAIrobi Service Request Confirmation - $referenceNumber',
      'body': '''
Dear ${formData['name']},

Thank you for your service request with nAIrobi. We have received your submission and will contact you soon.

Reference Number: $referenceNumber
Service Type: ${formData['serviceType']}
Service Requirements: ${formData['message']}

Best regards,
nAIrobi Team
      ''',
    };

    debugPrint('Sending emails: $internalEmail, $userEmail');
    // Placeholder for actual email sending logic
  }
}