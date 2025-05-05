import 'dart:async';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';


import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}