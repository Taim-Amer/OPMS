import 'package:flutter/material.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/utils/constants/colors.dart';

class TSidebar extends StatelessWidget {
  const TSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          color: TColors.white,
          border: Border(right: BorderSide(color: TColors.grey, width: 1))
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TRoundedContainer(
                backgroundColor: TColors.primary,
                radius: 20,
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.add, color: TColors.white,),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
