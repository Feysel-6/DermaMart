import 'package:dermamart/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:dermamart/utlis/constants/text_strings.dart';
import 'package:flutter/material.dart';

import '../../../../utlis/constants/sizes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ETexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: ESizes.spaceBtwSections),
              ESignupForm(),
            ],
          ),
        ),
      ),
    );
  }
}
