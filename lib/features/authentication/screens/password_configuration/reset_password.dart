import 'package:dermamart/common/widgets/login_signup/clear_button.dart';
import 'package:dermamart/common/widgets/success_screen/check_your_email.dart';
import 'package:flutter/material.dart';
import '../../../../utlis/constants/text_strings.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [ClearButton()],
      ),
      body: CheckYourEmail(
        title: ETexts.changeYourPasswordTitle,
        subTitle: ETexts.changeYourPasswordSubTitle,
        btnTxt: ETexts.done,
        onPressed: () {},
      ),
    );
  }
}
