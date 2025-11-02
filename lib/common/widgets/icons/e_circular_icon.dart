import 'package:flutter/material.dart';

import '../../../utlis/constants/colors.dart';
import '../../../utlis/helpers/helper_functions.dart';

class ECircularIcon extends StatelessWidget {
  const ECircularIcon({
    super.key,
    this.width,
    this.height,
    this.size,
    required this.icon,
    this.color,
    this.onPressed,
    this.backgroundColor,
  });

  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color:
            backgroundColor != null
                ? backgroundColor!
                : dark
                ? EColors.black.withValues(alpha: 0.9)
                : EColors.white.withValues(alpha: 0.9),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: color, size: size,),
      ),
    );
  }
}
