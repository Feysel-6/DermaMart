import 'package:flutter/material.dart';


import '../../../../utlis/constants/sizes.dart';
import '../../layout/grid_layout.dart';
import '../product_cards/product_card.dart';

class ESortableProducts extends StatelessWidget {
  const ESortableProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField(
          onChanged: (value) {},
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.sort),
          ),
          items:
          [
            'Name',
            'Higher Price',
            'Lower Price',
            'Sale',
            'Newest',
            'Popularity',
          ]
              .map(
                (option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            ),
          )
              .toList(),
        ),
        const SizedBox(height: ESizes.spaceBtwSections),
        EGridLayout(
          itemCount: 4,
          itemBuilder: (_, index) => EProductCard(),
        ),
      ],
    );
  }
}
