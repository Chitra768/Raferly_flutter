import 'package:get/get.dart';
import '../apis/rest_auth.dart';
import '../models/model_active_goal.dart';
import '../apis/api_result.dart';

class ActiveGoalController extends GetxController {
  var isLoading = false.obs;
  var activeGoals = <Data>[].obs;

  @override
  void onInit() {
    fetchActiveGoals();
    super.onInit();
  }

  void fetchActiveGoals() async {
    isLoading.value = true;
    final result = await RESTAuth.getActiveGoal(10, 1);
    if (result is ApiSuccess<ModelActiveGoal>) {
      activeGoals.value = result.data.data ?? [];
    }
    isLoading.value = false;
  }
}
