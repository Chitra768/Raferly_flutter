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
  static const updateCompanyType = 'update-company-type';
  static const profile = 'my-profile';
  static const updateCompanyProfile = 'update-company-profile';
  static const updateProfile = 'update-profile';
  static const dashboard = 'dashboard';
  static const updateSubscription = 'subscribe';
  static const submitFeedback = 'submitFeedback';
  static const getLeads = 'lead/receivedLead?';
  static const getSendLeads = 'lead/sentLead?';
  static const getArchiveList = 'lead/archivedLead?';
  static const deleteReceivedLead = 'lead/delete';
  static const recoverReceivedLead = 'lead/recoverArchivedLead';
  static const getAcceptList = 'deal/acceptList';
  static const getNetworkList = 'deal/networks';
  static const getContactList = 'deal/dealist';
  static const createDeal = 'deal/create';
  static const createLead = 'lead/create';
  static const updateLead = 'lead/update';
  static const updateDeal = 'deal/update';
  static const createLeadOutofRaferaly = 'lead/createSendOutLead';
  static const forgotPassword = 'forgot-password';
  static const verifyOtp = 'verify-otp';
  static const socialSignInSignUp = 'socialSignInSignUp';
  static const businessReferralLead = 'deal/see-all-business-referrers';
  static const businessReferralDealList = 'deal/index';
  static const deleteDeal = 'deal/delete';
  static const sendNotification = 'send-notification';
  static const getUserDealList = 'deal/userDealList';
  static const getActiveGoal = 'deal/activelist';
  static const getDocumentsList = 'deal/getDocumentsList';
  static const getHowItWorks = 'activity';
  static const readNotification = 'notification/read';
  static const dealDetail = 'deal/detail';
  static const dealAccept = 'deal/accept';
}
