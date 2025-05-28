import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/api_service.dart';

class LandingController extends GetxController {
  final RxString selectedOption = ''.obs;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final phoneController = TextEditingController();
  final landingFormKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs; // Added isLoading property

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    companyController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<bool> sendUserData(Map<String, dynamic> data) async {
    isLoading.value = true; // Set loading to true before API call
    final response = await ApiService.post(
      data,
      'https://events.lemolite360.in/leads',
    );
    isLoading.value = false; // Set loading to false after API call
    if (response != null && response.statusCode == 201) {
      // debugPrint('response=======>${response.body}');
      return true;
    }
    return false;
  }
}