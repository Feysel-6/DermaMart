import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utlis/constants/colors.dart';
import 'analysis_result.dart';

class AnalysisProcessingScreen extends StatefulWidget {
  final File imageCaptured;
  final String? skinType;

  const AnalysisProcessingScreen({
    super.key,
    required this.imageCaptured,
    this.skinType,
  });

  @override
  State<AnalysisProcessingScreen> createState() =>
      _AnalysisProcessingScreenState();
}

class _AnalysisProcessingScreenState extends State<AnalysisProcessingScreen>
    with TickerProviderStateMixin {
  late AnimationController _laserController;
  late AnimationController _progressController;
  late Animation<double> _laserAnimation;
  late Animation<double> _progressAnimation;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnalysis();
  }

  void _initializeAnimations() {
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _laserAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _laserController, curve: Curves.linear),
    );
    _laserController.repeat();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _progressController.addListener(() {
      setState(() => _progress = _progressAnimation.value);
    });
  }

  void _startAnalysis() {
    _progressController.forward();

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        Get.off(
              () => AnalysisResultScreen(
            imageCaptured: widget.imageCaptured,
            skinType: widget.skinType,
          ),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 300),
        );
      }
    });
  }

  @override
  void dispose() {
    _laserController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [ // <-- Missing '[' for the children list
          Positioned.fill(
            child: Image.file(widget.imageCaptured, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          AnimatedBuilder(
            animation: _laserAnimation,
            builder: (context, child) {
              final laserY = _laserAnimation.value * size.height;
              return Positioned.fill(
                child: CustomPaint(
                  painter: LaserScanPainter(laserY: laserY),
                  size: size,
                ),
              );
            },
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.0, 0.2, 0.8, 1.0],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: EColors.dermPink.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: EColors.dermPink, width: 3),
                      ),
                      child: Icon(
                        Icons.face_retouching_natural,
                        size: 80,
                        color: EColors.dermPink,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Analyzing Your Skin',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 10)],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please wait while we scan your face...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                      ),
                    ),
                    const SizedBox(height: 60),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: _progress,
                              minHeight: 8,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(EColors.dermPink),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${(_progress * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ), // <-- Missing ')' for Positioned.fill
        ],
      ), // <-- Missing ')' for Stack
    );
  }
}

class LaserScanPainter extends CustomPainter {
  final double laserY;

  LaserScanPainter({required this.laserY});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = EColors.dermPink.withOpacity(0.8)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawLine(Offset(0, laserY), Offset(size.width, laserY), paint);

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          EColors.dermPink.withOpacity(0.3),
          EColors.dermPink.withOpacity(0.5),
          EColors.dermPink.withOpacity(0.3),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, laserY - 50, size.width, 100));

    canvas.drawRect(
        Rect.fromLTWH(0, laserY - 50, size.width, 100), gradientPaint);

    final dotPaint = Paint()
      ..color = EColors.dermPink
      ..style = PaintingStyle.fill;

    final dotSpacing = size.width / 8;
    for (int i = 0; i < 8; i++) {
      final x = i * dotSpacing + dotSpacing / 2;
      canvas.drawCircle(Offset(x, laserY), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant LaserScanPainter oldDelegate) =>
      oldDelegate.laserY != laserY;
}