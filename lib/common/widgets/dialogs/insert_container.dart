import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/buttons/custom_button.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/images/rounded_image.dart';
import 'package:opms/utils/constants/assets.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';

class CustomInsertContainer extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;
  final VoidCallback onSubmit;
  final bool isLoading;
  final String title;
  final bool enableInsert;

  const CustomInsertContainer({
    super.key,
    required this.formKey,
    required this.fields,
    required this.onSubmit,
    this.isLoading = false,
    this.title = 'Insert form',
    this.enableInsert = true,
  });

  @override
  State<CustomInsertContainer> createState() => _CustomInsertContainerState();
}

class _CustomInsertContainerState extends State<CustomInsertContainer> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      type: MaterialType.transparency,
      child: SingleChildScrollView(
        child: TRoundedContainer(
          backgroundColor: dark ? TColors.dark : TColors.lightGrey,
          height: !HelperFunctions.isMobileScreen(context) ? 650.h : null,
          width: 400.w,
          padding: EdgeInsets.all(Sizes.secondaryPaddingSpace.w),
          child: Form(
            key: widget.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TRoundedImage(
                  imageUrl: ImagesAssets.add,
                  useHero: false,
                  width: 100.h,
                  height: 100.h,
                  backgroundColor: Colors.transparent,
                  borderRadius: 0,
                ),
                Sizes.spaceBtwSections.verticalSpace,
                widget.title.s17w700,
                Sizes.spaceBtwSections.verticalSpace,

                MouseRegion(
                  cursor: widget.enableInsert
                      ? SystemMouseCursors.click
                      : SystemMouseCursors.forbidden,
                  child: IgnorePointer(
                    ignoring: !widget.enableInsert,
                    child: Column(
                      children: List.generate(widget.fields.length, (index) {
                        final field = index == 0
                            ? Focus(
                          focusNode: _focusNode,
                          child: widget.fields[index],
                        )
                            : widget.fields[index];
                        return Column(
                          children: [
                            field,
                            if (index != widget.fields.length - 1)
                              Sizes.spaceBtwItems.verticalSpace,
                          ],
                        );
                      }),
                    ),
                  ),
                ),

                Sizes.spaceBtwItems.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    title: 'Insert',
                    cursor: widget.enableInsert
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.forbidden,
                    isLoading: widget.isLoading,
                    isColorsToggled: !widget.enableInsert,
                    onTap: widget.enableInsert ? widget.onSubmit : () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
