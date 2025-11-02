import 'package:dermamart/common/widgets/appbar/appbar.dart';
import 'package:dermamart/features/personalization/screens/address/widgets/add_new_address.dart';
import 'package:dermamart/features/personalization/screens/address/widgets/single_address.dart';
import 'package:dermamart/utlis/constants/colors.dart';
import 'package:dermamart/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: EColors.primary,
        onPressed: () => Get.to(() => const AddNewAddressScreen()),
        child: const Icon(Iconsax.add, color: EColors.white,),
      ),
      appBar: EAppBar(
        showBackArrow: true,
        title: Text('Addresses', style: Theme
            .of(context)
            .textTheme
            .headlineSmall,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ESizes.defaultSpace), child: Column(
          children: [
            ESingleAddress(selectedAddress: true),
            ESingleAddress(selectedAddress: false),
          ],
        ),),
      ),
    );
  }
}
