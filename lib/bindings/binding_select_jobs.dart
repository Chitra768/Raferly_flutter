import 'package:get/get.dart';
import 'package:referaly/controller/select_jobs_controller.dart';

class BindingSelectJobs extends Bindings {
  final bool isSingleSelection;
  
  BindingSelectJobs({this.isSingleSelection = false});
  
  @override
  void dependencies() {
    Get.lazyPut(() => SelectJobsController(isSingleSelection: isSingleSelection));
  }
}

