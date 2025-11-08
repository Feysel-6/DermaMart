import 'package:dermamart/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:dermamart/features/shop/screens/home/widgets/home_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/custom_shapes/containers/analyser_container.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/layout/grid_layout.dart';
import '../../../../common/widgets/products/product_cards/product_card.dart';
import '../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../data/controller/product_controller.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/sizes.dart';
import '../all_products/all_products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent, // Transparent status bar
      ),
    );
    return Scaffold(
      backgroundColor: EColors.dermBg,
      body: SingleChildScrollView(
        child: Column(
          children: [

            EPrimaryHeaderContainer(
              child: Column(
                children: [
                  EHomeAppBar(),
                  SizedBox(height: ESizes.spaceBtwHeader),

                  EAnalyserContainer(),

                  SizedBox(height: ESizes.spaceBtwHeader),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ESectionHeading(
                          title: 'Popular Categories',
                          showActionButton: false,
                          textColor: EColors.black,
                        ),
                        const SizedBox(height: ESizes.spaceBtwItems),
                        EHomeCategories(),
                      ],
                    ),
                  ),

                  const SizedBox(height: ESizes.spaceBtwSections / 2),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  ESectionHeading(
                    title: 'Popular Products',
                    onPressed: () => Get.to(() => const AllProducts()),
                  ),
                  Obx(
                          () {
                        if (controller.isLoading.value) {
                          return const EVerticalProductShimmer();
                        }
                        if (controller.featuredProducts.isEmpty) {
                          return Center(child: Text('No products found!', style: Theme.of(context).textTheme.titleMedium,),);
                        } else {
                          return EGridLayout(
                            itemCount: controller.featuredProducts.length,
                            itemBuilder: (_, index) => EProductCard(product: controller.featuredProducts[index]),
                          );
                        }
                      }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
