import 'package:dermamart/features/shop/screens/product_reviews/widgets/overall_product_rating.dart';
import 'package:dermamart/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/products/ratings/rating_indicator.dart';
import '../../../../utlis/constants/sizes.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EAppBar(title: Text('Reviews & Ratings'), showBackArrow: true,),

      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ratings and reviews are verified and are from people who use the same type of device that you use'),
              SizedBox(height: ESizes.spaceBtwItems,),

              EOverallProductRating(),
              ERatingBarIndicator(rating: 4.8,),
              Text('12,611', style: Theme.of(context).textTheme.bodySmall,),
              SizedBox(height: ESizes.spaceBtwSections,),
              EUserReviewCard(),
              EUserReviewCard(),
              EUserReviewCard(),

            ],
          ),
        ),
      ),
    );
  }
}




