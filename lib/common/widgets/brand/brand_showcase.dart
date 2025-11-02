import 'package:flutter/material.dart';

import '../../../utlis/constants/colors.dart';
import '../../../utlis/constants/sizes.dart';
import '../../../utlis/helpers/helper_functions.dart';
import '../custom_shapes/containers/rounded_container.dart';
import 'brand_card.dart';

class EBrandShowcase extends StatelessWidget {
  const EBrandShowcase({
    super.key, required this.images,
  });

  final List<String> images;

  @override
  Widget build(BuildContext context) {

    return ERoundedContainer(
      padding: const EdgeInsets.all(ESizes.md),
      showBorder: true,
      borderColor: EColors.darkGrey,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.only(
        bottom: ESizes.spaceBtwItems,
      ),
      child: Column(
        children: [
          const EBrandCard(showBorder: false),
          Row(
            children: images.map((image) =>
                brandTopProductImageWidget(image, context)).toList(),
          ),
        ],
      ),
    );
  }

  Widget brandTopProductImageWidget(String image, context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Expanded(
      child: ERoundedContainer(
        height: 100,
        backgroundColor:
        dark ? EColors.darkerGrey : EColors.light,
        margin: const EdgeInsets.only(right: ESizes.sm),
        padding: const EdgeInsets.all(ESizes.md),
        child: Image(
          fit: BoxFit.contain,
          image: AssetImage(image),
        ),
      ),
    );
  }
}