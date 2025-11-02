import 'package:dermamart/common/widgets/appbar/appbar.dart';
import 'package:dermamart/common/widgets/brand/brand_card.dart';
import 'package:dermamart/common/widgets/layout/grid_layout.dart';
import 'package:dermamart/common/widgets/texts/section_heading.dart';
import 'package:dermamart/features/shop/screens/brand/brand_products.dart';
import 'package:dermamart/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EAppBar(title: Text('Brand'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              ESectionHeading(title: 'Brands', showActionButton: false),
              SizedBox(height: ESizes.spaceBtwItems),

              EGridLayout(
                itemCount: 10,
                mainAxisExtent: 80,
                itemBuilder:
                    (context, index) => EBrandCard(
                      showBorder: true,
                      onTap: () => Get.to(() => BrandProducts()),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
