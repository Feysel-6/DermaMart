import 'package:dermamart/features/shop/screens/product/widgets/bottom_add_to_cart_widget.dart';
import 'package:dermamart/features/shop/screens/product/widgets/product_attribute.dart';
import 'package:dermamart/features/shop/screens/product/widgets/product_detail_image_slider.dart';
import 'package:dermamart/features/shop/screens/product/widgets/product_meta_data.dart';
import 'package:dermamart/features/shop/screens/product/widgets/rating_share_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utlis/constants/sizes.dart';
import '../product_reviews/product_reviews.dart';


class ProductDetainScreen extends StatelessWidget {
  const ProductDetainScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: EBottomAddToCart(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            EProductImageSlider(),

            Padding(
              padding: EdgeInsets.only(
                right: ESizes.defaultSpace,
                left: ESizes.defaultSpace,
                bottom: ESizes.defaultSpace,
              ),
              child: Column(
                children: [
                  ERatingAndShare(),

                  EProductMetaData(),

                  EProductAttribute(),
                  const SizedBox(height: ESizes.spaceBtwSections),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Checkout"),
                    ),
                  ),
                  const SizedBox(height: ESizes.spaceBtwSections),

                  ESectionHeading(
                    title: 'Description',
                    showActionButton: false,
                  ),
                  const SizedBox(height: ESizes.spaceBtwItems),

                  const ReadMoreText(
                    'Elevate your performance with the Blue Nike Sleeve, engineered for comfort, support, and style. Made with a breathable, moisture-wicking fabric blend, this compression sleeve keeps you cool and dry during intense workouts or casual wear. The ergonomic design allows full range of motion while providing targeted muscle support, reducing fatigue and improving recovery.Featuring the iconic Nike swoosh and a sleek blue finish, this sleeve combines performance with aesthetics. It’s perfect for athletes, gym enthusiasts, or anyone needing light joint support. Machine washable and designed for all-day wear, the Blue Nike Sleeve is your reliable training companion.Available in multiple sizes for the perfect fit. Wear it solo or pair it with your favorite Nike gear.',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Show more ',
                    trimExpandedText: ' Less',
                    moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  
                  const Divider(),
                  const SizedBox(height: ESizes.spaceBtwItems,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ESectionHeading(title: 'Reviews(199)', showActionButton: false,),
                      IconButton(onPressed: () => Get.to(() => const ProductReviewsScreen()), icon: Icon(Iconsax.arrow_right_3, size: 18,))
                    ],
                  ),
                  const SizedBox(height: ESizes.spaceBtwSections,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
