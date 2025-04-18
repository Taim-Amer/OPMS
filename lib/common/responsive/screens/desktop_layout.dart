import 'package:flutter/material.dart';
import 'package:opms/common/widgets/layouts/headers/header.dart';
import 'package:opms/common/widgets/layouts/sidebars/sidebar.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key, this.body});

  final Widget? body;

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
