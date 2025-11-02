import 'package:flutter/material.dart';

import '../../../../../common/widgets/products/cart/add_remove_button.dart';
import '../../../../../common/widgets/products/cart/cart_item.dart';
import '../../../../../common/widgets/texts/product_price_text.dart';
import '../../../../../utlis/constants/sizes.dart';

class ECartItems extends StatelessWidget {
  const ECartItems({
    super.key, this.showAddRemoveButton = true,
  });

  final bool showAddRemoveButton;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder:
          (_, index) => const SizedBox(height: ESizes.spaceBtwSections),
      itemCount: 2,
      itemBuilder:
          (_, index) => Column(
        children: [
          ECartItem(),
          if(showAddRemoveButton) SizedBox(height: ESizes.spaceBtwItems),

          if(showAddRemoveButton)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 70),
                  EProductQuantity(),
                ],
              ),
              EProductPriceText(price: '256'),
            ],
          ),
        ],
      ),
    );
  }
}