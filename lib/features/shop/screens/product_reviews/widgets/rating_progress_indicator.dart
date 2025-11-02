import 'package:flutter/material.dart';

import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/device/device_utility.dart';

class ERatingProgressIndicator extends StatelessWidget {
  const ERatingProgressIndicator({
    super.key, required this.text, required this.value,
  });

  final String text;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(text, style: Theme.of(context).textTheme.bodyMedium,)),
        Expanded(
          flex: 11,
          child: SizedBox(
            width: EDeviceUtils.getScreenWidth(context) * 0.8,
            child: LinearProgressIndicator(
              backgroundColor: EColors.grey,
              minHeight: 11,
              value: value,
              borderRadius: BorderRadius.circular(7),
              valueColor: AlwaysStoppedAnimation(EColors.primary),
            ),
          ),
        )

      ],
    );
  }
}