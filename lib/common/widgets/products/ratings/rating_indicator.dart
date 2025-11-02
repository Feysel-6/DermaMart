import 'package:dermamart/utlis/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';

class ERatingBarIndicator extends StatelessWidget {
  const ERatingBarIndicator({
    super.key, required this.rating,
  });

  final double rating;

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(rating: rating, itemSize: 20, itemBuilder: (_, __) => Icon(Iconsax.star1, color: EColors.primary,), unratedColor: EColors.grey, );
  }
}