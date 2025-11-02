import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utlis/constants/colors.dart';
import '../../../utlis/constants/enums.dart';
import '../../../utlis/constants/sizes.dart';
import 'e_brand_title_text.dart';

class EBrandTitleWithVerifiedIcon extends StatelessWidget {
  const EBrandTitleWithVerifiedIcon({
    super.key,
    required this.title,
    this.maxLines = 1,
    this.textColor,
    this.iconColor = EColors.primary,
    this.textAlign = TextAlign.center,
    this.brandTextSize = TextSizes.small,
  });

  final String title;
  final int maxLines;
  final Color? textColor, iconColor;
  final TextAlign? textAlign;
  final TextSizes brandTextSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: EBrandTitleText(
            title: title,
            color: textColor,
            maxLines: maxLines,
            textAlign: textAlign,
            brandTextSize: brandTextSize,
          ),
        ),
        const SizedBox(width: ESizes.xs),
        Icon(
          Iconsax.verify5,
          color: EColors.primary,
          size: ESizes.iconXs,
        ),
      ],
    );
  }
}
