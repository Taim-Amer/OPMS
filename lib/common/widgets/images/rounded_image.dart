import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/loaders/shimmer_loader.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';


class TRoundedImage extends StatelessWidget {
  const TRoundedImage({
    super.key,
    this.padding,
    this.border,
    this.width,
    this.height,
    this.onPressed,
    required this.imageUrl,
    this.applyImageRadius = true,
    this.fit = BoxFit.cover,
    this.backgroundColor = TColors.light,
    this.isNetworkImage = false,
    this.borderRadius = TSizes.md,
    this.heroTag = '',
    this.isImageClickable = false,
    this.useHero = true,
  });

  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;
  final String heroTag;
  final bool isImageClickable;
  final bool useHero;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return useHero ? GestureDetector(
      onTap: isImageClickable
          ? () {
        onPressed?.call();
        Navigator.push(
          context,
          PageRouteBuilder(
            fullscreenDialog: true,
            opaque: false,
            pageBuilder: (_, __, ___) => FullScreenImage(imageUrl: imageUrl ?? '', heroTag: heroTag, isNetwork: isNetworkImage,),
          ),
        );
      } : null,
      child: Hero(
        tag: heroTag,
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            border: border,
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ClipRRect(
            borderRadius: applyImageRadius ? BorderRadius.circular(borderRadius) : BorderRadius.zero,
            child: isNetworkImage ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: fit,
              placeholder: (context, url) => const ShimmerLoader(width: double.infinity, height: double.infinity),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ) : Image.asset(
              imageUrl,
              fit: fit,
            ),
          ),
        ),
      ),
    ) : GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(border: border, color: backgroundColor, borderRadius: BorderRadius.circular(borderRadius)),
        child: ClipRRect(
          borderRadius: applyImageRadius ? BorderRadius.circular(borderRadius) : BorderRadius.zero,
          child: isNetworkImage ? CachedNetworkImage(
            imageUrl: imageUrl,
            fit: fit,
            placeholder: (context, url) => const ShimmerLoader(width: double.infinity, height: double.infinity),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ) : Image.asset(
            imageUrl,
            fit: fit,
          ),
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  const FullScreenImage({super.key, required this.imageUrl, required this.heroTag, required this.isNetwork});

  final String imageUrl;
  final String heroTag;
  final bool isNetwork;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.secondary.withOpacity(.5),
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Hero(
              tag: heroTag,
              child: Material(
                type: MaterialType.transparency,
                child: TRoundedContainer(
                  width: 1.sw / 2,
                  height: 1.sw / 2,
                  radius: 400.r,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: isNetwork ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ShimmerLoader(width: double.infinity, height: double.infinity),
                      errorWidget: (context, url, error) =>  const Icon(Icons.error),
                    ) : Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

