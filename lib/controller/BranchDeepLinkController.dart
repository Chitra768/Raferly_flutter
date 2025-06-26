import 'dart:async';
import 'package:get/get.dart';

class BranchDeepLinkController extends GetxController {
  final Rxn<Map<dynamic, dynamic>> _branchData = Rxn<Map<dynamic, dynamic>>();
  final Completer<void> _branchReady = Completer<void>();

  bool get hasValidDeepLink =>
      _branchData.value?['+clicked_branch_link'] == true &&
          _branchData.value?['deal_id'] != null;

  String? get dealId => _branchData.value?['deal_id']?.toString();
  Map? get data => _branchData.value;

  void updateBranchData(Map<dynamic, dynamic> data) {
    _branchData.value = data;
    if (!_branchReady.isCompleted) _branchReady.complete();
  }

  Future<void> waitForBranchData() => _branchReady.future;
}
