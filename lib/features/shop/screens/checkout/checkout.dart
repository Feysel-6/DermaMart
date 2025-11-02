import 'package:dermamart/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:dermamart/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:dermamart/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/products/cart/coupon_widget.dart';
import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../navigation_menu.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/image_strings.dart';
import '../../../../utlis/constants/sizes.dart';
import '../../../../utlis/helpers/helper_functions.dart';
import '../cart/widgets/cart_items.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: EAppBar(
        showBackArrow: true,
        title: Text(
          'Checkout',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              ECartItems(showAddRemoveButton: false),
              SizedBox(height: ESizes.spaceBtwSections),

              ECouponCode(),
              SizedBox(height: ESizes.spaceBtwSections),

              ERoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(ESizes.md),
                backgroundColor: dark ? EColors.black : EColors.white,
                child: Column(
                  children: [
                    EBillingAmountSection(),
                    const SizedBox(height: ESizes.spaceBtwItems,),

                    const Divider(),
                    const SizedBox(height: ESizes.spaceBtwItems,),

                    EBillingPaymentSection(),
                    const SizedBox(height: ESizes.spaceBtwItems / 2,),

                    EBillingAddressSection(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(ESizes.defaultSpace),
        child: ElevatedButton(onPressed: () => Get.to(() => SuccessScreen(image: EImages.successfulPaymentIcon, title: 'Payment Success', description: 'Your item will be shipped soon!', onPressed: () => Get.offAll(() => const NavigationMenu()))), child: Text('Checkout \$256')),
      ),
    );
  }
}


