import 'package:flutter/material.dart';
import 'package:opms/common/responsive/responsive_design.dart';
import 'package:opms/common/responsive/screens/desktop_layout.dart';
import 'package:opms/common/responsive/screens/mobile_layout.dart';
import 'package:opms/common/responsive/screens/tablet_layout.dart';

class TSiteTemplate extends StatelessWidget {
  const TSiteTemplate({super.key, this.desktop, this.tablet, this.mobile, this.useLayout = true});

  final Widget? desktop;
  final Widget? tablet;
  final Widget? mobile;
  final bool useLayout;

  @override
  Widget build(BuildContext context) {
    return TResponsiveWidget(
      desktop: useLayout ? DesktopLayout(body: desktop) : desktop ?? const SizedBox(),
      tablet: useLayout ? TabletLayout(body: tablet ?? desktop,) : tablet ?? desktop ?? const SizedBox(),
      mobile: useLayout ? MobileLayout(body: mobile ?? desktop,) : mobile ?? desktop ?? const SizedBox(),
    );
  }
}
