import 'package:flutter/material.dart';

import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../common/widgets/images/e_circular_image.dart';
import '../../../../../common/widgets/texts/e_brand_title_text_with_verified_icon.dart';
import '../../../../../common/widgets/texts/product_price_text.dart';
import '../../../../../common/widgets/texts/product_title_text.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/enums.dart';
import '../../../../../utlis/constants/sizes.dart';
import '../../../../../utlis/helpers/helper_functions.dart';

class EProductMetaData extends StatelessWidget {
  const EProductMetaData({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ERoundedContainer(
              radius: ESizes.sm,
              backgroundColor: EColors.secondary.withValues(alpha: 0.8),
              padding: const EdgeInsets.symmetric(
                horizontal: ESizes.sm,
                vertical: ESizes.xs,
              ),
              child: Text(
                '25%',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.apply(color: EColors.black),
              ),
            ),
            const SizedBox(width: ESizes.spaceBtwItems,),
            Text('\$250', style: Theme.of(context).textTheme.titleSmall!.apply(decoration: TextDecoration.lineThrough),),
            const SizedBox(width: ESizes.spaceBtwItems,),
            EProductPriceText(price: '175', isLarge: true,),
          ],
        ),
        const SizedBox(height: ESizes.spaceBtwItems / 1.5,),

        EProductTitleText(title: 'Glycolic Acid 7% Exfoliating Toner | 23% Off in Slowvember'),
        const SizedBox(height: ESizes.spaceBtwItems / 1.5,),

        Row(
          children: [
            EProductTitleText(title: 'Status'),
            const SizedBox(width: ESizes.spaceBtwItems,),
            Text('In Stock', style: Theme.of(context).textTheme.titleMedium,),
          ],
        ),
        const SizedBox(height: ESizes.spaceBtwItems / 1.5,),

        Row(
          children: [
            ECircularImage(
              isNetworkImage: false,
              image: "assets/icons/brands/rareBeauty.png",
                width: 32, height: 32, overlayColor: dark ? EColors.white : EColors.black
            ),
            EBrandTitleWithVerifiedIcon(
              title: 'Rare Beauty',
              brandTextSize: TextSizes.medium,
            ),
          ],
        ),

      ],
    );
  }
}
