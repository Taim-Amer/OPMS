import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/admin/budget/models/equipments_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/common/extensions/text_extensions.dart';

class EquipmentItem extends StatelessWidget {
  const EquipmentItem({super.key, required this.equipment});

  final Equipment equipment;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return TRoundedContainer(
      showBorder: true,
      radius: 12.r,
      borderColor: dark ? TColors.darkBorder : TColors.lightBorder,
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      backgroundColor: dark ? TColors.dark : TColors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextWidget(
                text: (equipment.type ?? 'Equipment Type').s16w700,
                fontSize: 18,
                color: dark ? TColors.light : TColors.dark,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.description_outlined, size: 18, color: Colors.blue),
              SizedBox(width: 6.w),
              Expanded(
                child: TextWidget(
                  text: (equipment.equipmentDescription ?? 'No description').s14w400,
                  fontSize: 14,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              const Icon(Icons.monetization_on_outlined, size: 18, color: Colors.green),
              SizedBox(width: 6.w),
              TextWidget(
                text: 'Cost: ${equipment.equipmentCost ?? '0'}'.s14w700,
                fontSize: 14,
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
