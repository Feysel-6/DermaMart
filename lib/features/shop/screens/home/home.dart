import 'package:dermamart/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:dermamart/features/shop/screens/home/widgets/home_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/custom_shapes/containers/analyser_container.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/layout/grid_layout.dart';
import '../../../../common/widgets/products/product_cards/product_card.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/sizes.dart';
import '../all_products/all_products.dart';

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
  {'name': 'Moisturizers', 'icon': Iconsax.drop1, 'color': EColors.dermTeal},
  {'name': 'Cleansers', 'icon': Iconsax.box_remove, 'color': EColors.dermSky},
  {'name': 'Serums', 'icon': Iconsax.magic_star, 'color': EColors.dermOrange},
  {'name': 'Masks', 'icon': Iconsax.mask, 'color': EColors.dermLavender},
  {'name': 'Exfoliators', 'icon': Iconsax.refresh, 'color': EColors.dermMint},
  {
    'name': 'Toners',
    'icon': Iconsax.colorfilter,
    'color': EColors.dermLightBlue,
  },
  {'name': 'Eye Care', 'icon': Iconsax.eye, 'color': EColors.dermGold},
  {'name': 'Lips Care', 'icon': Iconsax.lamp_charge, 'color': EColors.dermRose},
  {
    'name': 'Men’s Care',
    'icon': Iconsax.user_octagon,
    'color': EColors.dermGray,
  },
  {
    'name': 'Doctor Recommended',
    'icon': Iconsax.shield_tick,
    'color': EColors.dermIndigo,
  },
  {
    'name': 'Sensitive Skin',
    'icon': Iconsax.warning_2,
    'color': EColors.dermPeach,
  },
  {
    'name': 'Beauty Tools',
    'icon': Iconsax.designtools,
    'color': EColors.dermBrown,
  },
  {'name': 'New Arrivals', 'icon': Iconsax.box_add, 'color': EColors.dermCyan},
  {'name': 'Best Sellers', 'icon': Iconsax.star, 'color': EColors.dermAmber},
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

                  EHomeCategories(categories: categories),

                  const SizedBox(height: ESizes.spaceBtwSections),
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
                  EGridLayout(
                    itemCount: 4,
                    itemBuilder: (_, index) => const EProductCard(),
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
