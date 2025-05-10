class ApiPath {
  // ***** API Request URL *****

  /// Development server
  static const baseUrl = 'https://refearly-back.developmentlabs.co/api/';

  /// Production server
  ///static const baseUrl = 'https://app.referaly.fr/api/';

  static const deviceAndroid = 'android';
  static const deviceIoS = 'ios';
  static const deviceWeb = 'browser';
  static const userType = 'user';

  /// Auth
  static const login = 'login';
  static const register = 'register';
  static const profile = 'my-profile';
  static const updateCompanyProfile = 'update-company-profile';
  static const updateProfile = 'update-profile';
  static const dashboard = 'dashboard';
}
