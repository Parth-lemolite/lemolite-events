import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/enums.dart';

class AppController extends GetxController {
  final Rx<FlowType?> selectedFlowType = Rx<FlowType?>(null);
  final RxBool isSubmitted = false.obs;

  void selectFlowType(FlowType type) {
    selectedFlowType.value = type;
    debugPrint('Selected flow: $type');
  }

  void resetFlow() {
    selectedFlowType.value = null;
    isSubmitted.value = false;
    debugPrint('Flow reset');
  }
}