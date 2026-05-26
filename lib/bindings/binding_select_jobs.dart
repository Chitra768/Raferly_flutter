import 'package:get/get.dart';
import 'package:referaly/controller/select_jobs_controller.dart';

class BindingSelectJobs extends Bindings {
  final bool isSingleSelection;
  final int? initialJobId;

  BindingSelectJobs({this.isSingleSelection = false, this.initialJobId});

  @override
  void dependencies() {
    Get.lazyPut(
      () => SelectJobsController(
        isSingleSelection: isSingleSelection,
        initialJobId: initialJobId,
      ),
    );
  }
}

