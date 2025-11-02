import 'package:dermamart/common/widgets/appbar/appbar.dart';
import 'package:dermamart/common/widgets/images/e_circular_image.dart';
import 'package:dermamart/common/widgets/texts/section_heading.dart';
import 'package:dermamart/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:dermamart/utlis/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utlis/constants/sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EAppBar(title: Text('Profile'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    ECircularImage(image: EImages.user, width: 80, height: 80),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Change Profile Picture'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: ESizes.spaceBtwItems),
              ESectionHeading(
                title: 'Profile Information',
                showActionButton: false,
              ),
              const SizedBox(height: ESizes.spaceBtwItems),

              EProfileMenu(
                title: 'Name',
                value: 'Coded By Fe',
                onPressed: () {},
              ),
              EProfileMenu(
                title: 'Username',
                value: 'coded_by_fe',
                onPressed: () {},
              ),

              const SizedBox(height: ESizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: ESizes.spaceBtwItems),

              const ESectionHeading(
                title: 'Personal Information',
                showActionButton: false,
              ),
              const SizedBox(height: ESizes.spaceBtwItems),

              EProfileMenu(
                title: 'User Id',
                value: '83393',
                onPressed: () {},
                icon: Iconsax.copy,
              ),
              EProfileMenu(
                title: 'E-mail',
                value: 'feyselteshome05@gmail.com',
                onPressed: () {},
              ),
              EProfileMenu(
                title: 'Phone Number',
                value: '+251967485693',
                onPressed: () {},
              ),
              EProfileMenu(title: 'Gender', value: 'Male', onPressed: () {}),
              EProfileMenu(
                title: 'Date of Birth',
                value: '10 Oct, 1994',
                onPressed: () {},
              ),
              const Divider(),
              const SizedBox(height: ESizes.spaceBtwItems),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Close Account',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
