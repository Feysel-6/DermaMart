import 'package:flutter/material.dart';

import '../../../../../common/widgets/brand/brand_showcase.dart';
import '../../../../../common/widgets/layout/grid_layout.dart';
import '../../../../../common/widgets/products/product_cards/product_card.dart';
import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utlis/constants/sizes.dart';

class ECategoryTab extends StatelessWidget {
  const ECategoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              EBrandShowcase(
                images: [
                  "assets/images/products/glycirin.png",
                  "assets/images/products/glycirin.png",
                  "assets/images/products/glycirin.png",
                ],
              ),
              const SizedBox(height: ESizes.spaceBtwItems),

              ESectionHeading(
                title: 'You might like',
                showActionButton: true,
                onPressed: () {},
              ),
              const SizedBox(height: ESizes.spaceBtwItems),

              EGridLayout(
                itemCount: 4,
                itemBuilder: (_, index) => EProductCard(),
              ),
              SizedBox(height: ESizes.spaceBtwSections,)
            ],
          ),
        ),
      ],
    );
  }
}
