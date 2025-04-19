import 'package:intl/intl.dart';

class TFormatter {
  TFormatter._();

  static String formatDate(String? dateString) {
    final date = dateString != null ? DateTime.parse(dateString) : DateTime.now();
    return DateFormat("yyyy MMMM dd").format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: "en_Us", symbol: "\$").format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('+')) {
      phoneNumber = phoneNumber.substring(1);

      if (phoneNumber.length == 12) {
        return "+(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6)}";
      } else if (phoneNumber.length == 13) {
        return "+(${phoneNumber.substring(0, 4)}) ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7)}";
      }
    }
    return phoneNumber;
  }


  static String internationalFormatPhoneNumber(String phoneNumber) {
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    String countryCode = "+${digitsOnly.substring(0,2)}";
    digitsOnly = digitsOnly.substring(2);

    final formattedNumber = StringBuffer();
    formattedNumber.write("($countryCode) ");

    int i = 0;
    while(i < digitsOnly.length) {
      int groupLength = 2 ;
      if(i==0 && countryCode == '+1'){
        groupLength = 3;
      }

      int end = i + groupLength;
      formattedNumber.write(digitsOnly.substring(i, end));

      if(end < digitsOnly.length) {
        formattedNumber.write(" ");
      }
      i = end;
    }
    return phoneNumber;
  }
}