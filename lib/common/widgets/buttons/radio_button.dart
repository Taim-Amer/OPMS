import 'package:flutter/material.dart';

class TRadioButton<T extends Enum> extends StatelessWidget {
  const TRadioButton({
    super.key,
    required this.enumValue,
    required this.valueNotifier,
    this.onChanged,
  });

  final T enumValue;
  final ValueNotifier<T?> valueNotifier;
  final void Function(T?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T?>(
      valueListenable: valueNotifier,
      builder: (context, selectedValue, child) {
        return Radio<T>(
          value: enumValue,
          groupValue: selectedValue,
          onChanged: (T? newValue) {
            if (newValue != null) {
              valueNotifier.value = newValue;
              if (onChanged != null) {
                onChanged!(newValue);
              }
            }
          },
        );
      },
    );
  }
}
