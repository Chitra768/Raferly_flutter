import 'package:get/get.dart';

class CompanyProfileController extends GetxController {
  final companyName = ''.obs;
  final description = ''.obs;
  final address = ''.obs;
  final businessCode = ''.obs;
  final profileImage = ''.obs;
  final companyId = ''.obs;
  final companyCountryCode = ''.obs;
  final industry = ''.obs;
  final country = ''.obs;

  void setCompanyData({
    required String name,
    required String desc,
    required String addr,
    required String code,
    required String image,
    required String id,
    required String countryCode,
    required String ind,
    required String cntry,
  }) {
    companyName.value = name;
    description.value = desc;
    address.value = addr;
    businessCode.value = code;
    profileImage.value = image;
    companyId.value = id;
    companyCountryCode.value = countryCode;
    industry.value = ind;
    country.value = cntry;
  }
}
