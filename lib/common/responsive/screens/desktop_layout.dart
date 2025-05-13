import 'package:flutter/material.dart';
import 'package:opms/common/widgets/layouts/sidebars/sidebar.dart';

class DesktopLayout extends StatelessWidget {
  DesktopLayout({super.key, this.body, this.actions = const []});

  final Widget? body;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            flex: 1,
            child: TSidebar(),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [Expanded(child: body ?? const SizedBox())],
            ),
          )
        ],
      ),
    );
  }
}
