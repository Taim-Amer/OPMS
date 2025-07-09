// lib/features/planner/plan_implementation/view/widgets/fields_section.dart

import 'package:flutter/material.dart';
import 'package:opms/features/planner/plan_implementation/controller/plan_implementation_conrtoller.dart';
import 'package:opms/utils/constants/colors.dart';

class FieldsSection extends StatelessWidget {
  final PlanImplementationController ctrl;
  final bool isEditable;
  const FieldsSection({
    super.key,
    required this.ctrl,
    required this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: isDark ? TColors.white : TColors.black,
      fontSize: 14.8,
      letterSpacing: 0.02,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PlanField(
          label: "Target Type",
          labelStyle: textStyle,
          child: isEditable
              ? TextFormField(
                  initialValue: ctrl.model?.targetType ?? '',
                  decoration: _inputDecoration('Target Type', isDark),
                  onChanged: ctrl.setTargetType,
                )
              : _PlanValueText(ctrl.model?.targetType),
        ),

        // ── TARGET NUMBER ─────────────────────────────────────────────────────
        _PlanField(
          label: "Target Number",
          labelStyle: textStyle,
          child: isEditable
              ? TextFormField(
                  initialValue: ctrl.model?.targetNum?.toString() ?? '',
                  decoration: _inputDecoration('Target Number', isDark),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    // empty or invalid → 0
                    final n = v.trim().isEmpty
                        ? 0
                        : (int.tryParse(v.trim()) ?? 0);
                    ctrl.setTargetNum(n);
                  },
                )
              : _PlanValueText(ctrl.model?.targetNum?.toString()),
        ),

        _PlanField(
          label: "Beneficiary Type",
          labelStyle: textStyle,
          child: isEditable
              ? Builder(builder: (context) {
                  final apiValue = ctrl.model?.beneficiaryType;
                  final items = List<String>.from(ctrl.beneficiaryTypes);
                  if (apiValue != null &&
                      apiValue.isNotEmpty &&
                      !items.contains(apiValue)) {
                    items.add(apiValue);
                  }
                  return DropdownButtonFormField<String>(
                    value: (apiValue != null && apiValue.isNotEmpty)
                        ? apiValue
                        : null,
                    items: items
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e, style: textStyle)))
                        .toList(),
                    decoration: _inputDecoration('Beneficiary Type', isDark),
                    onChanged: ctrl.setBeneficiaryType,
                  );
                })
              : _PlanValueText(ctrl.model?.beneficiaryType),
        ),

        // ── TOTAL BENEFICIARIES ────────────────────────────────────────────────
        _PlanField(
          label: "Total Beneficiaries",
          labelStyle: textStyle,
          child: isEditable
              ? TextFormField(
                  initialValue:
                      ctrl.model?.totalBeneficiaries?.toString() ?? '',
                  decoration: _inputDecoration('Total Beneficiaries', isDark),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    final n = v.trim().isEmpty
                        ? 0
                        : (int.tryParse(v.trim()) ?? 0);
                    ctrl.setTotalBeneficiaries(n);
                  },
                )
              : _PlanValueText(ctrl.model?.totalBeneficiaries?.toString()),
        ),
      ],
    );
  }
}

class _PlanField extends StatelessWidget {
  final String label;
  final Widget child;
  final TextStyle? labelStyle;
  const _PlanField({required this.label, required this.child, this.labelStyle});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: labelStyle),
          const SizedBox(height: 4.5),
          child,
        ],
      ),
    );
  }
}

class _PlanValueText extends StatelessWidget {
  final String? value;
  const _PlanValueText(this.value);
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
      decoration: BoxDecoration(
        color: isDark ? TColors.crese900.withOpacity(0.19) : TColors.crese50,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: TColors.crese100, width: 1),
      ),
      child: Text(
        value ?? '-',
        style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w400),
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint, bool isDark) => InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
      filled: true,
      fillColor: isDark ? TColors.crese900.withOpacity(0.8) : Colors.white,
      isDense: true,
    );
