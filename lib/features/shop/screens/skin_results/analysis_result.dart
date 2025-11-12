
import 'dart:io';

import 'package:dermamart/features/shop/screens/home/home.dart';
import 'package:dermamart/features/shop/screens/skin_results/widgets/image_display.dart';
import 'package:dermamart/features/shop/screens/skin_results/widgets/report_card.dart';
import 'package:dermamart/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/layout/grid_layout.dart';
import '../../../../common/widgets/products/product_cards/product_card.dart';
import '../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../data/controller/product_controller.dart';
import '../../../../utlis/constants/colors.dart';
import 'package:flutter/services.dart';

import '../all_products/all_products.dart';

class AnalysisResultScreen extends StatefulWidget {
  const AnalysisResultScreen({
    super.key,
    required this.imageCaptured,
    this.skinType,
  });

  final File imageCaptured;
  final String? skinType;

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );
    return Scaffold(
      backgroundColor: EColors.dermBg,
      appBar: EAppBar(
        title: Text(
          "Skin Analysis Report",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            height: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Get.to(() => NavigationMenu());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ImageDisplayer(imageCaptured: widget.imageCaptured),
              if (widget.skinType != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Detected Skin Type: ${widget.skinType}',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              DietSummaryCard(
                animationController: _animationController,
                animation: _animation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
