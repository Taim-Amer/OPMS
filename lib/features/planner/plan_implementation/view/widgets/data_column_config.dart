import 'package:flutter/material.dart';

class DataColumnConfig<T> {
  /// Column header text
  final String label;

  /// If non-null, applies as a fixed width.
  final double? fixedWidth;

  /// Builds a DataCell for the given row (item + index).
  final DataCell Function(T item, int rowIndex) cellBuilder;

  const DataColumnConfig({
    required this.label,
    this.fixedWidth,
    required this.cellBuilder,
  });
}