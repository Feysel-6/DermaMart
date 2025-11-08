import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import '../../../../../common/widgets/layout/grid_layout.dart';
import '../../../../../common/widgets/products/product_cards/product_card.dart';
import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../data/controller/product_controller.dart';
import '../../../../../utlis/constants/fitness_app_theme.dart';
import '../../all_products/all_products.dart';


class AppTheme {
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFFAFAFAF);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);
  static const Color darkerText = Color(0xFF1F2844);
}

// Utility to convert hex strings to Color objects
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}

// --- 2. Custom Painter for Calorie Ring (Essential Dependency) ---

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  CurvePainter({required this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    const double radians = math.pi / 180;
    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);

    // Create a sweep gradient for the circular arc
    final gradient = SweepGradient(
      startAngle: (270 - angle) * radians,
      endAngle: 360 * radians,
      tileMode: TileMode.clamp,
      colors: colors,
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    // Draw the arc based on the calculated angle
    double startAngle = -90 * radians;
    double sweepAngle = angle * radians;

    // The original logic is complex, this approximation makes the card work visually.
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CurvePainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.colors != colors;
  }
}

// --- 3. Extracted and Modified Widget (MediterranesnDietView) ---

class DietSummaryCard extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const DietSummaryCard({super.key, this.animationController, this.animation});

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;

    return AnimatedBuilder(
      animation: animationController ?? const AlwaysStoppedAnimation(1.0),
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              30 * (1.0 - animation!.value),
              0.0,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 6,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: FitnessAppTheme.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                        topRight: Radius.circular(68.0),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: FitnessAppTheme.grey.withOpacity(0.2),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                            left: 16,
                            right: 16,
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    top: 4,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            height: 48,
                                            width: 2,
                                            decoration: BoxDecoration(
                                              color: HexColor(
                                                '#87A0E5',
                                              ).withOpacity(0.5),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(4.0),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                    left: 4,
                                                    bottom: 2,
                                                  ),
                                                  child: Text(
                                                    'General Skin Health',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FitnessAppTheme.fontName,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      letterSpacing: -0.1,
                                                      color: FitnessAppTheme.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 28,
                                                      height: 28,
                                                      child: Icon(
                                                        Icons
                                                            .face_retouching_natural,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 4,
                                                            bottom: 3,
                                                          ),
                                                      child: Text(
                                                        'Good',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              FitnessAppTheme
                                                                  .fontName,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                          color: FitnessAppTheme
                                                              .darkerText,
                                                        ),
                                                      ),
                                                    ),
                                                    // Padding(
                                                    //   padding:
                                                    //       const EdgeInsets.only(
                                                    //         left: 4,
                                                    //         bottom: 3,
                                                    //       ),
                                                    //   child: Text(
                                                    //     'Kcal',
                                                    //     textAlign: TextAlign.center,
                                                    //     style: TextStyle(
                                                    //       fontFamily:
                                                    //           FitnessAppTheme
                                                    //               .fontName,
                                                    //       fontWeight:
                                                    //           FontWeight.w600,
                                                    //       fontSize: 12,
                                                    //       letterSpacing: -0.2,
                                                    //       color: FitnessAppTheme
                                                    //           .grey
                                                    //           .withOpacity(0.5),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            height: 48,
                                            width: 2,
                                            decoration: BoxDecoration(
                                              color: HexColor(
                                                '#F56E98',
                                              ).withOpacity(0.5),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(4.0),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                    left: 4,
                                                    bottom: 2,
                                                  ),
                                                  child: Text(
                                                    'Skin Type',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FitnessAppTheme.fontName,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      letterSpacing: -0.1,
                                                      color: FitnessAppTheme.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 28,
                                                      height: 28,
                                                      child: Icon(Icons.spa),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 4,
                                                            bottom: 3,
                                                          ),
                                                      child: Text(
                                                        'Dry',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              FitnessAppTheme
                                                                  .fontName,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                          color: FitnessAppTheme
                                                              .darkerText,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 8,
                                                            bottom: 3,
                                                          ),
                                                      // child: Text(
                                                      //   '%',
                                                      //   textAlign: TextAlign.center,
                                                      //   style: TextStyle(
                                                      //     fontFamily:
                                                      //         FitnessAppTheme
                                                      //             .fontName,
                                                      //     fontWeight:
                                                      //         FontWeight.w600,
                                                      //     fontSize: 12,
                                                      //     letterSpacing: -0.2,
                                                      //     color: FitnessAppTheme
                                                      //         .grey
                                                      //         .withOpacity(0.5),
                                                      //   ),
                                                      // ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Center(
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: FitnessAppTheme.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(100.0),
                                            ),
                                            border: Border.all(
                                              width: 4,
                                              color: FitnessAppTheme.nearlyDarkBlue
                                                  .withOpacity(0.2),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                '${(87 * animation!.value).toInt()} %',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FitnessAppTheme.fontName,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 24,
                                                  letterSpacing: 0.0,
                                                  color: FitnessAppTheme
                                                      .nearlyDarkBlue,
                                                ),
                                              ),
                                              // Text(
                                              //   'Kcal left',
                                              //   textAlign: TextAlign.center,
                                              //   style: TextStyle(
                                              //     fontFamily:
                                              //         FitnessAppTheme.fontName,
                                              //     fontWeight: FontWeight.bold,
                                              //     fontSize: 12,
                                              //     letterSpacing: 0.0,
                                              //     color: FitnessAppTheme.grey
                                              //         .withOpacity(0.5),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: CustomPaint(
                                          painter: CurvePainter(
                                            colors: [
                                              FitnessAppTheme.nearlyDarkBlue,
                                              HexColor("#8A98E8"),
                                              HexColor("#8A98E8"),
                                            ],
                                            angle:
                                                140 +
                                                (360 - 140) *
                                                    (1.0 - animation!.value),
                                          ),
                                          child: SizedBox(width: 108, height: 108),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: FitnessAppTheme.background,
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            top: 8,
                            bottom: 16,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Hydration',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            letterSpacing: -0.2,
                                            color: FitnessAppTheme.darkText,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Container(
                                            height: 4,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              color: HexColor(
                                                '#87A0E5',
                                              ).withOpacity(0.2),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(4.0),
                                              ),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width:
                                                      ((70 / 1.2) *
                                                      animation!.value),
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        HexColor('#87A0E5'),
                                                        HexColor(
                                                          '#87A0E5',
                                                        ).withOpacity(0.5),
                                                      ],
                                                    ),
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(4.0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 6),
                                          child: Text(
                                            'poor',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color: FitnessAppTheme.grey
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Pigmentation',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily:
                                                    FitnessAppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: -0.2,
                                                color: FitnessAppTheme.darkText,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 4,
                                              ),
                                              child: Container(
                                                height: 4,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  color: HexColor(
                                                    '#F56E98',
                                                  ).withOpacity(0.2),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          ((70 / 2) *
                                                          animationController!
                                                              .value),
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            HexColor(
                                                              '#F56E98',
                                                            ).withOpacity(0.1),
                                                            HexColor('#F56E98'),
                                                          ],
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(4.0),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 6,
                                              ),
                                              child: Text(
                                                'sensetive',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FitnessAppTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: FitnessAppTheme.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Acne',
                                              style: TextStyle(
                                                fontFamily:
                                                    FitnessAppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: -0.2,
                                                color: FitnessAppTheme.darkText,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 0,
                                                top: 4,
                                              ),
                                              child: Container(
                                                height: 4,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  color: HexColor(
                                                    '#F1B440',
                                                  ).withOpacity(0.2),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          ((70 / 2.5) *
                                                          animationController!
                                                              .value),
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            HexColor(
                                                              '#F1B440',
                                                            ).withOpacity(0.1),
                                                            HexColor('#F1B440'),
                                                          ],
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(4.0),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 6,
                                              ),
                                              child: Text(
                                                'normal',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FitnessAppTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: FitnessAppTheme.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                  top: 8,
                                  bottom: 8,
                                ),
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: FitnessAppTheme.background,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4.0),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Description',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            letterSpacing: -0.2,
                                            color: FitnessAppTheme.darkText,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'Your skin analysis shows a balanced complexion with moderate hydration and slight oiliness in the T-zone. Overall texture is smooth with mild unevenness on the forehead. Light pigmentation and small pores are visible but manageable. Your skin health is good—maintain hydration, gentle cleansing, and daily sunscreen to keep it glowing.',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [

                      ESectionHeading(
                        title: 'Recommended Products',
                        onPressed: () => Get.to(() => const AllProducts()),
                      ),
                      // EGridLayout(
                      //   itemCount: 4,
                      //   itemBuilder: (_, index) => const EProductCard(),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

