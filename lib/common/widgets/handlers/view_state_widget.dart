import 'package:flutter/material.dart';
import 'package:opms/utils/constants/enums.dart';

class ViewStateWidget extends StatelessWidget {
  const ViewStateWidget({
    required this.requestState,
    required this.child,
    this.emptyWidget,
    this.errorWidget,
    this.loadingWidget,
    super.key,
  });

  final RequestState requestState;
  final Widget child;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return switch (requestState) {
      RequestState.begin => child,
      RequestState.success => child,
      RequestState.empty => emptyWidget ?? child,
      RequestState.error => errorWidget ?? child,
      RequestState.loading => loadingWidget ?? child,
    };
  }
}
