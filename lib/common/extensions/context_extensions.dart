import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {

  Size get size => MediaQuery.of(this).size;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  double get pixelRatio => MediaQuery.of(this).devicePixelRatio;

  Brightness get platformBrightness => MediaQuery.of(this).platformBrightness;

  double get statusBarHeight => MediaQuery.of(this).padding.top;

  double get navigationBarHeight => MediaQuery.of(this).padding.bottom;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  FormState? get formState => Form.of(this);

  ScaffoldState get scaffoldState => Scaffold.of(this);

  OverlayState? get overlayState => Overlay.of(this);

  Color get primaryColor => theme.primaryColor;

  Color get accentColor => theme.colorScheme.secondary;

  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  Color get cardColor => theme.cardColor;

  Color get dividerColor => theme.dividerColor;

  Color get iconColor => theme.iconTheme.color!;

  void requestFocus(FocusNode focus) {
    FocusScope.of(this).requestFocus(focus);
  }

  void unFocus(FocusNode focus) {
    focus.unfocus();
  }

  Orientation get orientation => MediaQuery.of(this).orientation;

  bool get isLandscape => orientation == Orientation.landscape;

  bool get isPortrait => orientation == Orientation.portrait;

  TargetPlatform get platform => Theme.of(this).platform;

  bool get isAndroid => platform == TargetPlatform.android;

  bool get isIOS => platform == TargetPlatform.iOS;

  bool get isMacOS => platform == TargetPlatform.macOS;

  bool get isWindows => platform == TargetPlatform.windows;

  bool get isFuchsia => platform == TargetPlatform.fuchsia;

  bool get isLinux => platform == TargetPlatform.linux;

  void openDrawer() => Scaffold.of(this).openDrawer();

  void openEndDrawer() => Scaffold.of(this).openEndDrawer();
}
