import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/list_tile/settings_menu_tile.dart';
import '../../../../common/widgets/list_tile/user_profile_tile.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/sizes.dart';
import '../../../shop/screens/order/order.dart';
import '../address/address.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            EPrimaryHeaderContainer(
              child: Column(
                children: [
                  EAppBar(
                    title: Text(
                      'Account',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.apply(color: EColors.white),
                    ),
                  ),

                  EUserProfileTile(),
                  const SizedBox(height: ESizes.spaceBtwSections),
                ],
              ),
            ),

            Padding(padding: const EdgeInsets.all(ESizes.defaultSpace),
            child: Column(
              children: [
                ESectionHeading(title: 'Account Setting', showActionButton: false,),
                SizedBox(height: ESizes.spaceBtwItems,),
                ESettingMenuTile(icon: Iconsax.safe_home, title: 'My Addresses', subTitle: 'Set shopping delivery address', onTap: () => Get.to(() => const UserAddressScreen()),),
                ESettingMenuTile(icon: Iconsax.shopping_cart, title: 'My Cart', subTitle: 'Add, remove products and move to checkout', onTap: (){},),
                ESettingMenuTile(icon: Iconsax.bag_tick, title: 'My Order', subTitle: 'In-progress and Completed Orders', onTap: () => Get.to(() => const OrderScreen()),),
                ESettingMenuTile(icon: Iconsax.bank, title: 'Bank Account', subTitle: 'Withdraw balance to registered bank account', onTap: (){},),
                ESettingMenuTile(icon: Iconsax.discount_shape, title: 'My Coupons', subTitle: 'List of all the discounted coupons', onTap: (){},),
                ESettingMenuTile(icon: Iconsax.notification, title: 'Notifications', subTitle: 'Set any kind of notification message', onTap: (){},),
                ESettingMenuTile(icon: Iconsax.security_card, title: 'Account Privacy', subTitle: 'Manage data usage and connected accounts', onTap: (){},),
                
                SizedBox(height: ESizes.spaceBtwSections,),
                ESectionHeading(title: 'App Settings', showActionButton: false,),
                SizedBox(height: ESizes.spaceBtwItems,),
                ESettingMenuTile(icon: Iconsax.document_upload, title: 'Load Data', subTitle: 'Upload Data to your Cloud Firebase'),
                ESettingMenuTile(icon: Iconsax.location, title: 'Geolocation', subTitle: 'Get recommendation based on location', trailing: Switch(value: true, onChanged: (value){}),),
                ESettingMenuTile(icon: Iconsax.security_user, title: 'Safe Mode', subTitle: 'Search result is safe for all ages', trailing: Switch(value: false, onChanged: (value){}),),
                ESettingMenuTile(icon: Iconsax.image, title: 'HD Image Quality', subTitle: 'Set image quality to be seen', trailing: Switch(value: false, onChanged: (value){}),),
                const SizedBox(height: ESizes.spaceBtwSections),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(onPressed: (){}, child: const Text('Logout')),
                ),
                const SizedBox(height: ESizes.spaceBtwSections * 2.5 ,)

              ],
            ),)
          ],
        ),
      ),
    );
  }
}


