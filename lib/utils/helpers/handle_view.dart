import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/utils/constants/enums.dart';

// ignore: must_be_immutable
class HandleView extends StatelessWidget {
  final Rx<RequestState> status;
  final Widget Function()? successView;
  final Widget loadingWidget;
  final Widget? errorWidget;
  final Widget defaultWidget;

  const HandleView({
    super.key,
    required this.status,
    this.successView,
    required this.loadingWidget,
    this.errorWidget,
    required this.defaultWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (status.value) {
        case RequestState.loading:
          return loadingWidget;

        case RequestState.error:
          return errorWidget!;
        case RequestState.begin:
          return defaultWidget;

        case RequestState.success:
          return successView!();

        default:
          return const SizedBox.shrink();
      }
    });
  }
}
