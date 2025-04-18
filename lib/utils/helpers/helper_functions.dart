import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';

class THelperFunctions {

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  static String truncateText(String text, int maxLength){
    if(text.length < maxLength) {
      return text;
    }else{
      return '${text.substring(0, maxLength)} ... .';
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
    return MediaQuery.of(context).size.width >= TSizes.desktopScreenSize;
  }

  static bool isTabletScreen(BuildContext context){
    return MediaQuery.of(context).size.width >= TSizes.tabletScreenSize && MediaQuery.of(context).size.width < TSizes.desktopScreenSize;
  }

  static bool isMobileScreen(BuildContext context){
    return MediaQuery.of(context).size.width < TSizes.tabletScreenSize;
  }
}
