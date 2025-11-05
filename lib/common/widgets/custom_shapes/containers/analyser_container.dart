import 'package:flutter/material.dart';
import 'dart:io';

import '../../../../features/shop/screens/skin_results/analysis_result.dart';
import '../../../../utlis/constants/colors.dart';
import 'analyzer_dialog.dart';
import 'package:get/get.dart';

class EAnalyserContainer extends StatefulWidget {
  const EAnalyserContainer({super.key});

  @override
  State<EAnalyserContainer> createState() => _EAnalyserContainerState();
}

class _EAnalyserContainerState extends State<EAnalyserContainer> {
  File? _imageCaptured;

  void _openCameraDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AnalyzerDialog(
        onImageCaptured: (File image) {
          if (mounted) {
            setState(() {
              _imageCaptured = image;
            });
            Get.to(() => AnalysisResultScreen(imageCaptured: image));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 24.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: EColors.dermDark.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              padding: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                gradient: const LinearGradient(
                  colors: [EColors.dermPink, EColors.dermDark, EColors.dermPink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: EColors.dermBg,
                  borderRadius: BorderRadius.circular(borderRadius - 1),
                  gradient: RadialGradient(
                    colors: [
                      EColors.dermPink.withOpacity(0.1),
                      EColors.dermDark.withOpacity(0.05),
                      EColors.dermBg
                    ],
                    center: Alignment.topLeft,
                    radius: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _imageCaptured == null
                        ? _buildScanningVisual()
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        _imageCaptured!,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Instant Skin Insights',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Get a personalized analysis of your skin and discover products tailored for you.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, height: 1.3),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildCtaButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanningVisual() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: EColors.dermDark.withOpacity(0.8),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: EColors.dermPink.withOpacity(0.7),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.face_retouching_natural,
          size: 70,
          color: EColors.dermBg.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _buildCtaButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _openCameraDialog,
      icon: const Icon(Icons.camera_alt, size: 20),
      label: const Text(
        'Analyze My Skin',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: EColors.dermDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        elevation: 8,
      ),
    );
  }
}
