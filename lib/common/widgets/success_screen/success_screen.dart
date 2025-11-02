import 'package:flutter/material.dart';

import '../../../utlis/constants/sizes.dart';
import '../../../utlis/constants/text_strings.dart';
import '../../../utlis/helpers/helper_functions.dart';
import '../../styles/spacing_style.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.onPressed,
  });

  final String image, title, description;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: ESpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              Image(
                image: AssetImage(image),
                width: EHelperFunctions.screenWidth() * 0.6,
              ),
              SizedBox(height: ESizes.spaceBtwSections),

              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ESizes.spaceBtwItems),

              Text(
                description,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ESizes.spaceBtwItems),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text(ETexts.tContinue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
