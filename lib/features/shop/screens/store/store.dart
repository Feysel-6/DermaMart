import 'package:dermamart/features/shop/screens/store/widgets/category_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/appbar/tabbar.dart';
import '../../../../common/widgets/brand/brand_card.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/layout/grid_layout.dart';
import '../../../../common/widgets/products/cart/cart_menu_icon.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/sizes.dart';
import '../../../../utlis/helpers/helper_functions.dart';
import '../brand/all_brands.dart';

final List<Map<String, dynamic>> categories = [
  {'name': 'Skincare', 'icon': Iconsax.drop, 'color': EColors.dermPink},
  {'name': 'Haircare', 'icon': Iconsax.scissor_1, 'color': EColors.dermBlue},
  {'name': 'Bodycare', 'icon': Iconsax.brush_2, 'color': EColors.dermGreen},
  {
    'name': 'Sun Protection',
    'icon': Iconsax.sun_1,
    'color': EColors.dermYellow,
  },
  {'name': 'Acne Treatment', 'icon': Iconsax.scan, 'color': EColors.dermRed},
  {'name': 'Anti-Aging', 'icon': Iconsax.clock, 'color': EColors.dermPurple},
  {'name': 'Cleansers', 'icon': Iconsax.box_remove, 'color': EColors.dermSky},
  {'name': 'Serums', 'icon': Iconsax.magic_star, 'color': EColors.dermOrange},
  {'name': 'Masks', 'icon': Iconsax.mask, 'color': EColors.dermLavender},
  {'name': 'Exfoliators', 'icon': Iconsax.refresh, 'color': EColors.dermMint},
  {
    'name': 'Toners',
    'icon': Iconsax.colorfilter,
    'color': EColors.dermLightBlue,
  },
];

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: EAppBar(
          title: Text(
            'Store',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [ECartCounterIcon(onPressed: () {})],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: dark ? EColors.black : EColors.white,
                expandedHeight: 400,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(ESizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: ESizes.spaceBtwItems),
                      const ESearchContainer(
                        text: 'Search in Store',
                        showBorder: true,
                        showBackground: false,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: ESizes.spaceBtwItems),
                      ESectionHeading(
                        title: 'Featured Brands',
                        onPressed: () => Get.to(() => const AllBrandsScreen()),
                      ),
                      const SizedBox(height: ESizes.spaceBtwItems / 1.5),
                      EGridLayout(
                        itemCount: 4,
                        mainAxisExtent: 80,
                        itemBuilder: (_, index) {
                          return const EBrandCard(showBorder: true);
                        },
                      ),
                    ],
                  ),
                ),
                bottom: ETabBar(
                  tabs: categories.map((cat) => Tab(text: cat['name'])).toList(),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: categories.map((_) => const ECategoryTab()).toList(),
          ),
        ),
      ),
    );
  }
}
