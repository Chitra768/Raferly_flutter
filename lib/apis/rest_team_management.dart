import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:referaly/apis/api_path.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/base_api.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_error.dart';
import 'package:referaly/models/model_team_member.dart';
import 'package:referaly/models/model_team_member_invite.dart';
import 'package:referaly/utils/translations.dart';

class RESTTeamManagement with BaseAPI {
  static final RESTTeamManagement _object = RESTTeamManagement();

  /// Stripe-checkout redirect URLs shared by the invite and switch-to-independent
  /// flows. `{CHECKOUT_SESSION_ID}` is substituted by Stripe.
  static const teamSeatSuccessUrl =
      'https://app.referaly.fr/team-management/independent-seat/success?session_id={CHECKOUT_SESSION_ID}';
  static const teamSeatCancelUrl = 'https://app.referaly.fr/team-management';

  static Future<ApiResult> getTeamMembers() async {
    const String tag = 'getTeamMembers';

    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: tr(LanguageKeys.noInternetConnection)));
    }

    _object.apiLog('$tag baseurl: ${ApiPath.baseUrl}');
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.getTeamMembers}');
    _object.apiLog('$tag URL: $url');

    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.get(url, headers: headers);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(TeamMemberListModel.fromJson(decodedResult));
      }

      if (response.statusCode == 422) {
        return ApiFailure(ModelError.fromJson(decodedResult));
      }

      return ApiFailure(
        ModelError(message: decodedResult['message'] ?? 'Something went wrong'),
      );
    } on SocketException {
      _object.onSocket(tag);
      return ApiFailure(ModelError(message: 'Unexpected error occurred'));
    } catch (error) {
      _object.onError(tag, error);
      return ApiFailure(ModelError(message: error.toString()));
    }
  }

  static Future<ApiResult> getTeamMemberSettings(int memberId) async {
    const String tag = 'getTeamMemberSettings';
    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: tr(LanguageKeys.noInternetConnection)));
    }
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.teamMemberSettings(memberId)}');
    _object.apiLog('$tag URL: $url');
    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.get(url, headers: headers);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      final decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(TeamMemberSettingsResponse.fromJson(decodedResult));
      }
      if (response.statusCode == 422) {
        return ApiFailure(ModelError.fromJson(decodedResult));
      }
      return ApiFailure(
        ModelError(message: decodedResult['message'] ?? 'Something went wrong'),
      );
    } on SocketException {
      _object.onSocket(tag);
      return ApiFailure(ModelError(message: 'Unexpected error occurred'));
    } catch (error) {
      _object.onError(tag, error);
      return ApiFailure(ModelError(message: error.toString()));
    }
  }

  static Future<ApiResult> saveTeamMemberSettings({
    required int memberId,
    required TeamMemberContentAccess contentAccess,
    bool switchToIndependent = false,
  }) async {
    const String tag = 'saveTeamMemberSettings';
    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: tr(LanguageKeys.noInternetConnection)));
    }
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.teamMemberSettings(memberId)}');
    final body = <String, dynamic>{
      if (!switchToIndependent) 'content_access': contentAccess.toJson(),
      'switch_to_independent': switchToIndependent,
      // BE creates a Stripe checkout session for the seat upgrade and uses
      // these redirects on success/cancel; owner gets an email notification.
      if (switchToIndependent) ...{
        'success_url': teamSeatSuccessUrl,
        'cancel_url': teamSeatCancelUrl,
        'notify_owner_by_email': true,
      },
    };
    _object.apiLog('$tag URL: $url body: ${jsonEncode(body)}');
    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.put(url, headers: headers, body: jsonEncode(body));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      final decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(TeamMemberSettingsResponse.fromJson(decodedResult));
      }
      if (response.statusCode == 422) {
        return ApiFailure(ModelError.fromJson(decodedResult));
      }
      return ApiFailure(
        ModelError(message: decodedResult['message'] ?? 'Something went wrong'),
      );
    } on SocketException {
      _object.onSocket(tag);
      return ApiFailure(ModelError(message: 'Unexpected error occurred'));
    } catch (error) {
      _object.onError(tag, error);
      return ApiFailure(ModelError(message: error.toString()));
    }
  }

  static Future<ApiResult> getTeamMemberProfile(int memberId) async {
    const String tag = 'getTeamMemberProfile';
    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: tr(LanguageKeys.noInternetConnection)));
    }
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.teamMemberProfile(memberId)}');
    _object.apiLog('$tag URL: $url');
    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.get(url, headers: headers);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');

      final decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(TeamMemberProfileResponse.fromJson(decodedResult));
      }
      if (response.statusCode == 422) {
        return ApiFailure(ModelError.fromJson(decodedResult));
      }
      return ApiFailure(
        ModelError(message: decodedResult['message'] ?? 'Something went wrong'),
      );
    } on SocketException {
      _object.onSocket(tag);
      return ApiFailure(ModelError(message: 'Unexpected error occurred'));
    } catch (error) {
      _object.onError(tag, error);
      return ApiFailure(ModelError(message: error.toString()));
    }
  }

  static Future<ApiResult> switchTeamMemberToAgency(int memberId) async {
    const String tag = 'switchTeamMemberToAgency';
    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: tr(LanguageKeys.noInternetConnection)));
    }
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.teamMemberSwitchToAgency(memberId)}');
    _object.apiLog('$tag URL: $url');
    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url, headers: headers, body: jsonEncode({'confirm': true}));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');
      
      final decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(decodedResult as Map<String, dynamic>);
      }
      if (response.statusCode == 422) {
        return ApiFailure(ModelError.fromJson(decodedResult));
      }
      return ApiFailure(
        ModelError(message: decodedResult['message'] ?? 'Something went wrong'),
      );
    } on SocketException {
      _object.onSocket(tag);
      return ApiFailure(ModelError(message: 'Unexpected error occurred'));
    } catch (error) {
      _object.onError(tag, error);
      return ApiFailure(ModelError(message: error.toString()));
    }
  }

  static Future<ApiResult> getTeamMemberContent({
    required int memberId,
    required String tab,
    int page = 1,
    int limit = 20,
  }) async {
    const String tag = 'getTeamMemberContent';
    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: tr(LanguageKeys.noInternetConnection)));
    }
    final url = Uri.parse(
      '${ApiPath.baseUrl}${ApiPath.teamMemberContent(memberId)}?tab=$tab&page=$page&limit=$limit',
    );
    _object.apiLog('$tag URL: $url');
    try {
      final headers = await _object.getHeaderWithToken();
      final response = await http.get(url, headers: headers);
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');
      
      final decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(TeamMemberContentResponse.fromJson(decodedResult));
      }
      if (response.statusCode == 422) {
        return ApiFailure(ModelError.fromJson(decodedResult));
      }
      return ApiFailure(
        ModelError(message: decodedResult['message'] ?? 'Something went wrong'),
      );
    } on SocketException {
      _object.onSocket(tag);
      return ApiFailure(ModelError(message: 'Unexpected error occurred'));
    } catch (error) {
      _object.onError(tag, error);
      return ApiFailure(ModelError(message: error.toString()));
    }
  }

  static Future<ApiResult> inviteTeamMember(TeamMemberInviteRequest request) async {
    const String tag = 'inviteTeamMember';
    if (!(await _object.hasInternet() ?? false)) {
      return ApiFailure(ModelError(message: tr(LanguageKeys.noInternetConnection)));
    }
    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.teamMembersInvite}');
    final body = request.toJson();
    _object.apiLog('$tag URL: $url body: ${jsonEncode(body)}');
    try {
      final headers = await _object.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';
      final response = await http.post(url, headers: headers, body: jsonEncode(body));
      _object.apiLog('$tag Response: Status Code: ${response.statusCode}');
      _object.apiLog('$tag Response: ${response.body}');
      
      final decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiSuccess(decodedResult as Map<String, dynamic>);
      }
      if (response.statusCode == 422) {
        return ApiFailure(ModelError.fromJson(decodedResult));
      }
      return ApiFailure(
        ModelError(message: decodedResult['message'] ?? 'Something went wrong'),
      );
    } on SocketException {
      _object.onSocket(tag);
      return ApiFailure(ModelError(message: 'Unexpected error occurred'));
    } catch (error) {
      _object.onError(tag, error);
      return ApiFailure(ModelError(message: error.toString()));
    }
  }
}
