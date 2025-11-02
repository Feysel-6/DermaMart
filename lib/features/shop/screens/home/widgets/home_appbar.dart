import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/products/cart/cart_menu_icon.dart';
import '../../../../../utlis/constants/text_strings.dart';

class EHomeAppBar extends StatelessWidget {
  const EHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return EAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ETexts.homeAppbarTitle,
            style: Theme.of(
              context,
            ).textTheme.labelLarge!.copyWith(
              color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.w600, // Semi-bold: gives presence but still soft
              letterSpacing: 0.5,
            ),
          ),
          Text(
            ETexts.homeAppbarSubTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w700, // Bold and confident
              letterSpacing: 0.3,
              height: 1.2,
            ),
          ),
        ],
      ),
      actions: [ Icon(Iconsax.search_normal4, color: Colors.black87,), ECartCounterIcon(onPressed: () {}, iconColor: Colors.black87),],
    );
  }
}
