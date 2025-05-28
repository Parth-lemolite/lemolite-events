import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/lead.dart';
import '../../service/api_service.dart';
import 'state.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class Leads_screenLogic extends GetxController {
  final Leads_screenState state = Leads_screenState();


  // Observable variables
  final selectedCategory = Rx<InterestedIn?>(null);
  final leads = <Datum>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // Delay the initial data fetch until after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLeads();
    });
  }

  static const String baseUrl =
      'https://events.lemolite360.in'; // Replace with your actual API URL

  Future<List<Datum>> getLeadsApi() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/leads'));
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('Empty response body');
        }

        final dynamic jsonData;
        try {
          jsonData = json.decode(response.body);
        } catch (e) {
          throw Exception('Failed to decode JSON: $e');
        }

        if (jsonData is List) {
          return jsonData.map((json) => Datum.fromJson(json)).toList();
        } else if (jsonData is Map<String, dynamic>) {
          final Lead leadResponse = Lead.fromJson(jsonData);
          return leadResponse.data ?? [];
        } else {
          throw Exception('Unexpected API response format: ${jsonData.runtimeType}');
        }
      } else {
        throw Exception('Failed to load leads: HTTP ${response.statusCode}');
      }
    } catch (e) {
      // Wrap and rethrow with detailed message
      throw Exception('Failed to load leads: ${e.toString()}');
    }
  }

  Future<void> getLeads() async {
    EasyLoading.show(status: 'Loading leads...');
    try {
      final List<Datum> datumList = await getLeadsApi();
      state.leads.value = datumList;

      EasyLoading.dismiss();
      Get.snackbar(
        'Success',
        'Leads loaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      EasyLoading.dismiss();
      // Ensure snackbar is shown after UI is ready
      Future.microtask(() {
        Get.snackbar(
          'Error',
          'Failed to load leads: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      });
    }
  }
}
