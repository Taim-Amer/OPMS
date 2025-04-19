import 'package:opms/app.dart';
import 'package:opms/utils/helpers/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();

  Get.testMode = true;

  await CacheHelper.init();

  runApp(const OPMSSystem());
}