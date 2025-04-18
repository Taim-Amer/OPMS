class TApiConstants {
  TApiConstants._();

  static const String baseUrl = 'https://pharmacy.technoplus.dev/api/';

  static const String darkMap = 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';

  static const String lightMap = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';

  static const String register = 'pharmacists/register';

  static const String verify = 'otp/verify';

  static const String resend = 'otp/resend';

  static const String forget = 'ForgetPassword';

  static const String forgetVerify = 'otp/password/verify';

  static const String forgetReset = 'resetPassword';

  static const String signin = 'pharmacist/login';

  static const String change = 'pharmacists/toggle-status';

  static const String confirm = 'order/confirm';

  static const String reject = 'order/reject';

  static const String getOrders = 'pharmacist/orders';

  static const String showOrder = 'order/show';

  static const String getDrivers = 'drivers';

  static const String assignOrder = 'order/assign-driver';

  static const String updateOrder = 'order/status/on_the_way';

  static const String addOrderPrice = 'order/add_price';

  static const String addDeliveryPrice = 'delivery-price';
}