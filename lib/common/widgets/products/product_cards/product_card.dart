import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../data/model/product_model.dart';
import '../../../../features/shop/screens/product/product.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/sizes.dart';
import '../../../../utlis/helpers/helper_functions.dart';
import '../../../styles/shadows.dart';
import '../../custom_shapes/containers/rounded_container.dart';
import '../../icons/e_circular_icon.dart';
import '../../images/e_rounded_image.dart';
import '../../texts/e_brand_title_text_with_verified_icon.dart';
import '../../texts/product_price_text.dart';
import '../../texts/product_title_text.dart';

class EProductCard extends StatelessWidget {
  const EProductCard({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => Get.to(() => const ProductDetainScreen()),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [EShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(ESizes.productImageRadius),
          color: dark ? EColors.darkerGrey : EColors.white,
        ),
        child: Column(
          children: [
            ERoundedContainer(
              height: 150,
              padding: const EdgeInsets.all(ESizes.sm),
              backgroundColor: dark ? EColors.dark : EColors.light,
              child: Stack(
                children: [
                  ERoundedImage(
                    imageUrl: product.image_path!,
                    isNetworkImage: true,
                    height: 300,
                    width: 400,
                    applyImageRadius: true,
                  ),
                  Positioned(
                    top: 12,
                    child: ERoundedContainer(
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
                  ),

                  Positioned(
                    top: 0,
                    right: 0,
                    child: ECircularIcon(
                      icon: Iconsax.heart5,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: ESizes.spaceBtwItems / 2),
            Padding(
              padding: EdgeInsets.only(left: ESizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EProductTitleText(
                    title: product.name,
                  ),
                  // SizedBox(height: ESizes.spaceBtwItems / 2),
                  EBrandTitleWithVerifiedIcon(title: product.brand!,),
                ],
              ),
            ),
            //Spacer(),
            Container(
              margin: const EdgeInsets.only(left: 7, right: 7),
              decoration: BoxDecoration(
                color: EColors.cream,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: EProductPriceText(price: product.price as String,),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: EColors.dark,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          child: Center(
                            child: const Icon(
                              Iconsax.add,
                              color: EColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}