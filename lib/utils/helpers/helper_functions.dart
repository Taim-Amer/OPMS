import 'package:opms/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HelperFunctions {
  HelperFunctions._();

  static String truncateText(String text, int maxLength){
    if(text.length < maxLength) {
      return text;
    }else{
      return '${text.substring(0, maxLength)} ... .';
    }
  }

  static String timeAgo(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp).toUtc();
    Duration difference = DateTime.now().toUtc().difference(dateTime).abs();

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes == 1) {
      return 'minute ago';
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else {
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
  }

  static bool isDarkMode(BuildContext context){
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize(){
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight(BuildContext? context){
    return MediaQuery.of(context ?? Get.context!).size.height;
  }

  static double screenWidth(BuildContext? context){
    return MediaQuery.of(context ?? Get.context!).size.width;
  }

  static String getFormattedDate(DateTime date, {String format = 'dd MMM yyyy'}){
    return DateFormat(format).format(date);
  }

  static List<T> removeDuplicates<T>(List<T> list){
    return list.toSet().toList();
  }

  static void updateApiStatus({required Rx<RequestState> target, required RequestState value}){
    target.value = value;
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize){
    final wrappedList = <Widget>[];
    for(var i=0 ; i<widgets.length ; i+=rowSize){
      final rowChildren = widgets.sublist(i, i+rowSize > widgets.length ? widgets.length : i+rowSize);
      wrappedList.add(Row(children: rowChildren,));
    }
    return wrappedList;
  }

  static bool isDesktopScreen(BuildContext context){
    return MediaQuery.of(context).size.width >= Sizes.desktopScreenSize;
  }

  static bool isTabletScreen(BuildContext context){
    return MediaQuery.of(context).size.width >= Sizes.tabletScreenSize && MediaQuery.of(context).size.width < Sizes.desktopScreenSize;
  }

  static bool isMobileScreen(BuildContext context){
    return MediaQuery.of(context).size.width < Sizes.tabletScreenSize;
  }

  static void visitUrl(String url) async {
    if(await canLaunchUrlString(url)){
      await launchUrlString(url);
    } else {
      throw "Could not launch $url";
    }
  }

  static List<T> search<T>(List<T> list, String query,
      {required List<String> Function(T item) searchFields,}) {
    final lowerQuery = query.toLowerCase();
    return list.where((item) {
      return searchFields(item).any((field) => field.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}
