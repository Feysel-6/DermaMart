import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import '../../../../../common/widgets/icons/e_circular_icon.dart';
import '../../../../../common/widgets/images/e_rounded_image.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/image_strings.dart';
import '../../../../../utlis/constants/sizes.dart';
import '../../../../../utlis/helpers/helper_functions.dart';

class EProductImageSlider extends StatelessWidget {
  const EProductImageSlider({super.key,});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

    return ECurvedEdgeWidget(
      child: Container(
        color: dark ? EColors.darkerGrey : EColors.light,
        child: Stack(
          children: [
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(ESizes.productImageRadius * 2),
                child: Center(
                  child: Image(image: AssetImage(EImages.productImage5)),
                ),
              ),
            ),

            Positioned(
              right: 0,
              bottom: 30,
              left: ESizes.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: AlwaysScrollableScrollPhysics(),
                  separatorBuilder:
                      (_, __) => const SizedBox(width: ESizes.spaceBtwItems),
                  itemCount: 4,
                  itemBuilder:
                      (_, index) => ERoundedImage(
                        width: 80,
                        imageUrl: EImages.productImage3,
                        backgroundColor: dark ? EColors.dark : EColors.white,
                        border: Border.all(color: EColors.primary),
                        padding: const EdgeInsets.all(ESizes.sm),
                      ),
                ),
              ),
            ),

            EAppBar(
              showBackArrow: true,
              actions: [
                ECircularIcon(
                  icon: Iconsax.heart5,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
