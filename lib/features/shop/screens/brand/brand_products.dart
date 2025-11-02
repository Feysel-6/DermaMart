import 'package:dermamart/common/widgets/appbar/appbar.dart';
import 'package:dermamart/common/widgets/brand/brand_card.dart';
import 'package:dermamart/common/widgets/products/sortable/sortable_products.dart';
import 'package:dermamart/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EAppBar(title: Text('Nike'), showBackArrow: true,),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(ESizes.defaultSpace),
        child: Column(
          children: [
            EBrandCard(showBorder: true),
            SizedBox(height: ESizes.spaceBtwSections,),

            ESortableProducts(),
          ],
        ),),
      ),
    );
  }
}
