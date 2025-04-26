import 'package:flutter/material.dart';
import 'package:opms/common/widgets/layouts/headers/header.dart';
import 'package:opms/features/sidebar/views/widgets/sidebar.dart';

class TabletLayout extends StatelessWidget {
  TabletLayout({super.key, this.body, required this.clickableSidebar});

  final Widget? body;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final bool clickableSidebar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: TSidebar(clickableSidebar: clickableSidebar,),
      appBar: THeader(scaffoldKey: scaffoldKey,),
      body: body ?? const SizedBox(),
    );
  }
}