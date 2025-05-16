import 'package:get/get.dart';
import 'package:referaly/controller/language_controller.dart';

String tr(String key) {
  return LanguageController.to.translate(key);
}
