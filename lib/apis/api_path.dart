class ApiPath {
  // ***** API Request URL *****

  /// Development server
  static const baseUrl = 'https://refearly-back.developmentlabs.co/api/';

  /// Production server
  // static const baseUrl = 'https://admin.referaly.fr/api/'; // Live Admin

  static const deviceAndroid = 'android';
  static const deviceIoS = 'ios';
  static const deviceWeb = 'browser';
  static const userType = 'user';

  /// Auth
  static const appVersion = 'app-version';
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
  static const getArchiveSendList = 'lead/archivedSentLead?';
  static const getArchivedLeadStatistics = 'lead/archivedLeadStats';
  static const getArchivedSentLeadStatistics = 'lead/archivedSentLeadStats';
  static const referralStatistics = 'lead/referralStatistics';
  static const overallStatistics = 'lead/overallStatistics';
  static const deleteReceivedLead = 'lead/delete';
  static const forceDeleteLead = 'lead/forceDelete';
  static const requestToUpdateLead = 'lead/requestToUpdateLead';
  static const recoverReceivedLead = 'lead/recoverArchivedLead';
  static const leadOpened = 'lead/lead-opened';
  static const getAcceptList = 'deal/acceptList';
  static const getNetworkList = 'deal/networks';
  static const getContactList = 'deal/dealist';
  static const createDeal = 'deal/create';
  static const createLead = 'lead/create';
  static const addLeadWithReferrer = 'lead/addLeadWithReferrer';
  static const updateLead = 'lead/update';
  static const updateLeadAmount = 'lead/updateAmount';
  static const updateDeal = 'deal/update';
  static const createLeadOutofRaferaly = 'lead/createSendOutLead';
  static const forgotPassword = 'forgot-password';
  static const verifyOtp = 'verify-otp';
  static const resetPassword = 'reset-password';
  static const resendVerificationEmail = 'resend-email-verification';
  static const verifyEmailToken = 'verify-email-token';
  static const socialSignInSignUp = 'socialSignInSignUp';
  static const businessReferralLead = 'deal/see-all-business-referrers';
  static const businessReferralDealList = 'deal/index';
  static const deleteDeal = 'deal/delete';
  static const deleteNetwork = 'deal/deleteNetwork';
  static const sendNotificationToBusinessReferrers =
      'deal/sendNotificationToBusinessReferrers';
  static const getUserDealList = 'deal/userDealList';
  static const getActiveGoal = 'deal/activelist';
  static const getDocumentsList = 'deal/getDocumentsList';
  static const getHowItWorks = 'activity';
  static const readNotification = 'notification/read';
  static const sendReferral = 'lead/createFinder';
  static const leadComment = 'lead/trackStep';
  static const updateLeadStatus = 'lead/update-status';
  static const dealDetail = 'deal/detail';
  static const dealAccept = 'deal/accept';
  static const getIndividualHome = 'update-company-type';
  static const alreadyHaveCard = 'generate-card-login';
  static const uploadDocument = 'deal/uploadDocuments';
  static const deleteDocument = 'deal/deleteDocument';
  static const updateDocumentName = 'deal/updateDocumentName';
  static const getDealLeave = 'deal/leave';
  static const sendNotificationInDeals = 'deal/sendNotificationInDeals';
  static const trackStepComment = 'lead/trackStepComment';
  static const deleteAccount = "user/delete-account";
  static const AgencyCoworkerList = "deal/collaboratorList";
  static const getTeamMembers = "deal/teamMembers";
  static const teamMembersInvite = "deal/teamMembers/invite";
  static String teamMemberSettings(int id) => "deal/teamMembers/$id/settings";
  static String teamMemberProfile(int id) => "deal/teamMembers/$id/profile";
  static String teamMemberSwitchToAgency(int id) => "deal/teamMembers/$id/switch_to_agency";
  static String teamMemberContent(int id) => "deal/teamMembers/$id/content";
  static const getCoworkerSearchList = "search";
  static const collaboratorDelete = "deal/collaboratorDelete";
  static const collaboratorAdd = "deal/addCollaboratorInDeals";
  static const addBusinessReferrer = "addBusinessReferrer";
  static const shareReferralForm = "lead/shareReferralForm";
  static const getOngoingRequests = "finders/on-going-requests";
  static const getFinderSuggestions = "finders/get-finder-suggestions";
  static const askForNetworking = "finders/ask-for-networking";
  static const saveFinderDetails = "finders/save-finder-details";
  static const respondToFinderRequest = "finders/respond-to-finder-request";
  static const deleteFinderRequest = "finders/delete-finder-request";
  static const getFinderBasicDetails = "finders/basic-details";
  static const getCategories = "finders/categories";
  static const getStatisticsForParent = "getStatisticsForParent";
  static const updateContact = "user/update-contact";
  static const getUserNotificationControl = "user-notification-control";
  static const updateUserNotificationControl = "user-notification-control/update";
  static const createPaymentIntent = "create-payment-intent";
  static const verifyPayment = "verify-payment";
  static const confirmPaymentMethod = "lead/confirmpaymentmethod";
  static const planDetail = "plan/detail";
}
