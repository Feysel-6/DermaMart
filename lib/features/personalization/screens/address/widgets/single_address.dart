import 'package:dermamart/utlis/constants/colors.dart';
import 'package:dermamart/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utlis/helpers/helper_functions.dart';

class ESingleAddress extends StatelessWidget {
  const ESingleAddress({super.key, required this.selectedAddress});

  final bool selectedAddress;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return ERoundedContainer(
      width: double.infinity,
      padding: EdgeInsets.all(ESizes.md),
      showBorder: true,
      backgroundColor:
          selectedAddress
              ? EColors.primary.withValues(alpha: 0.5)
              : Colors.transparent,
      borderColor:
          selectedAddress
              ? Colors.transparent
              : dark
              ? EColors.darkerGrey
              : EColors.grey,
      margin: EdgeInsets.only(bottom: ESizes.spaceBtwItems),
      child: Stack(
        children: [
          Positioned(
            right: 5,
            top: 0,
            child: Icon(
              selectedAddress ? Iconsax.tick_circle5 : null,
              color:
                  selectedAddress
                      ? dark
                          ? EColors.light
                          : EColors.dark
                      : null,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Meaza Ashenafi', maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleLarge,),
              const SizedBox(height: ESizes.sm / 2,),
              Text('(+251) 383 3892', maxLines: 1, overflow: TextOverflow.ellipsis,),
              const SizedBox(height: ESizes.sm / 2,),
              Text('93839 Gurara, Addis Ababa, Ferensay, 83938, Ethiopia', maxLines: 2, softWrap: true,),
            ],
          )
        ],
      ),
    );
  }
}
