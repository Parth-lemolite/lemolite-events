import 'package:get/get.dart';
import '../../models/lead.dart';

class Leads_screenState {
  final RxList<Datum> leads = <Datum>[].obs;
  final Rx<InterestedIn?> selectedCategory = Rx<InterestedIn?>(null);
  final RxString searchQuery = ''.obs;

  Leads_screenState();
}