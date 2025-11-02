import 'package:dermamart/features/authentication/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/login_signup/clear_button.dart';
import '../../../../common/widgets/success_screen/check_your_email.dart';
import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../utlis/constants/image_strings.dart';
import '../../../../utlis/constants/text_strings.dart';


class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [ClearButton()],
      ),
      body: SingleChildScrollView(
        child: CheckYourEmail(
          title: ETexts.confirmEmail,
          subTitle: ETexts.confirmEmailSubTitle,
          btnTxt: ETexts.tContinue,
          email: 'feyselteshome05@gmail.com',
          onPressed:
              () => Get.to(
                () => SuccessScreen(
                  image: EImages.staticSuccessIllustration,
                  title: ETexts.yourAccountCreatedTitle,
                  description: ETexts.yourAccountCreatedSubTitle,
                  onPressed: () => Get.to(() => const LoginScreen()),
                ),
              ),
        ),
      ),
    );
  }
}
