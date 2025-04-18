import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final Text text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  const TextWidget({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.data.toString(),
      style: text.style?.copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign ?? text.textAlign,
      textDirection: textDirection ?? text.textDirection,
      maxLines: maxLines ?? text.maxLines,
      overflow: overflow ?? text.overflow,
      softWrap: softWrap ?? text.softWrap,
    );
  }
}
