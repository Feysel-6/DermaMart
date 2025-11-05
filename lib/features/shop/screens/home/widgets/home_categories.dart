import 'package:dermamart/utlis/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/image_text_widgets/vertical_image_text.dart';


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

class EHomeCategories extends StatelessWidget {
  const EHomeCategories({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return EVerticalImageText(
            isIcon: true,
            image: categories[index]['icon'],
            title: categories[index]['name'],
            textColor: EColors.dark,
            onTap: () {});
        },
      ),
    );
  }
}