import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/admin/budget/models/training_description_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/common/extensions/text_extensions.dart';

class TrainingDescriptionItem extends StatelessWidget {
  const TrainingDescriptionItem({
    super.key,
    required this.trainingDescription,
    required this.onTap,
  });

  final TrainingDescription trainingDescription;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = dark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF5F5F5);

    final borderColor = dark ? Colors.grey.shade800 : Colors.grey.shade300;

    return TRoundedContainer(
      showBorder: true,
      radius: 12.r,
      borderColor: borderColor,
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      backgroundColor: backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextWidget(
              text: (trainingDescription.name ?? 'Training Name').s16w700,
              fontSize: 18,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: onTap,
            icon: const Icon(
              Icons.edit,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}

