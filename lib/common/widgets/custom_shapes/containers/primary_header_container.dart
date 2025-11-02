import 'package:flutter/cupertino.dart';

import '../../../../utlis/constants/colors.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

class EPrimaryHeaderContainer extends StatelessWidget {
  const EPrimaryHeaderContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ECurvedEdgeWidget(
      child: Container(
        color: EColors.dermBg,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
              top: -70,
              right: -120,
              child: ECircularContainer(
                backgroundColor: EColors.dermRed.withValues(alpha: 0.1),
              ),
            ),
            Positioned(
              top: -70,
              left: -120,
              child: ECircularContainer(
                backgroundColor: EColors.dermRed.withValues(alpha: 0.1),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
