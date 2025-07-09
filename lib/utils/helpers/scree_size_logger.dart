import 'dart:async' as html;
import 'dart:html' as html;
import 'package:flutter/material.dart';

class WebResizeLogger extends StatefulWidget {
  final Widget child;
  const WebResizeLogger({Key? key, required this.child}) : super(key: key);

  @override
  _WebResizeLoggerState createState() => _WebResizeLoggerState();
}

class _WebResizeLoggerState extends State<WebResizeLogger> {
  late final html.StreamSubscription<html.Event> _sub;

  @override
  void initState() {
    super.initState();
    // Log initial
    _logHtmlSize();
    // Listen for resize
    _sub = html.window.onResize.listen((_) => _logHtmlSize());
  }

  void _logHtmlSize() {
    final w = html.window.innerWidth;
    final h = html.window.innerHeight;
    debugPrint('🌐 Browser size: ${w}px × ${h}px');
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
