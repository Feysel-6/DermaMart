import 'package:flutter/material.dart';

import '../../utlis/constants/sizes.dart';

class ESpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: ESizes.appBarHeight,
    left: ESizes.defaultSpace,
    right: ESizes.defaultSpace,
    bottom: ESizes.defaultSpace,
  );
}