import 'package:flutter/material.dart';
import 'package:opms/common/responsive/responsive_design.dart';
import 'package:opms/features/home/views/screens/home_desktop_screen.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const TResponsiveWidget(
      mobile: HomeDesktopScreen(),
      desktop: HomeDesktopScreen(),
      tablet: HomeDesktopScreen(),
    );
  }
}
