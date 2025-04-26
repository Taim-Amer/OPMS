import 'package:flutter/material.dart';
import 'package:opms/common/widgets/layouts/headers/header.dart';
import 'package:opms/features/sidebar/views/widgets/sidebar.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key, this.body, required this.clickableSidebar});

  final Widget? body;
  final bool clickableSidebar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: TSidebar(clickableSidebar: clickableSidebar,),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                const THeader(),
                Expanded(child: body ?? const SizedBox())
              ],
            ),
          )
        ],
      ),
    );
  }
}
