import 'package:dermamart/common/widgets/appbar/appbar.dart';
import 'package:dermamart/features/shop/screens/order/widgets/orders_list.dart';
import 'package:dermamart/utlis/constants/sizes.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EAppBar(title: Text('My Orders', style: Theme.of(context).textTheme.headlineSmall,), showBackArrow: true,),
      body: Padding(
        padding: EdgeInsets.all(ESizes.defaultSpace),
        child: EOrderListItems(),
      ),
    );
  }
}
