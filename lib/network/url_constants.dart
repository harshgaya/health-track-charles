class UrlConstants {
  static const BASE_URL = "https://happytokenapi.softplix.com/api/";
  static const BASE_URL_2 = "https://happytokenapi.softplix.com/api/admin/";

  ///authentication
  static const sendOtp = '${BASE_URL}send-otp';
  static const verifyOtp = '${BASE_URL}verify-otp';
  static const sendOtpShop = '${BASE_URL}send-otp-shop';
  static const verifyOtpShop = '${BASE_URL}verify-otp-shop';
  static const addName = '${BASE_URL}addUserName';
  static const generatePreSignedUrl = '${BASE_URL}admin/generatePresignedUrl';

  ///banners and categories
  static const getAllBanners = '${BASE_URL}admin/getAllBanners';
  static const getAllCategory = '${BASE_URL}admin/getAllCategory';
  static const getCategoryShops = '${BASE_URL}/getShopsByCategory';

  ///shop
  static const addShopDetails = '${BASE_URL}addShopDetails';
  static const checkShopStatus = '${BASE_URL}checkShopStatus';
  static const getShopTransactions = '${BASE_URL}get-shop-transactions';
  static const getShopSettlements = '${BASE_URL_2}get-shop-settlements';
  static const getTodayTransactions = '${BASE_URL}get-shop-today-transactions';
  static const getLifetimeTransactions =
      '${BASE_URL}get-shop-lifetime-transactions';
  static const getMonthlyTransactions =
      '${BASE_URL}get-shop-monthly-transactions';

  ///user
  static const getVerifiedShops = '${BASE_URL}admin/getVerifiedShops';
  static const getSearchShop = '${BASE_URL}/getSearchShops';
  static const getNotification = '${BASE_URL}get-notifications-user';
  static const markNotificationRead = '${BASE_URL}mark-notification-read';

  ///payments
  static const getUserDetails = '${BASE_URL}get-user';
  static const getUserTransactions = '${BASE_URL}get-user-transactions';
  static const payUsingWallet = '${BASE_URL}payusingwallet';
  static const generateOrderId = '${BASE_URL}createRazorpayOrder';
  static const checkPaymentStatus = '${BASE_URL}checkRazorpayPaymentStatus';

  ///help
  static const getHelp = '${BASE_URL}getHelp';
}
