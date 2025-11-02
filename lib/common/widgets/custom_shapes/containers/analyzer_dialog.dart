import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../../../utlis/constants/colors.dart';
// Note: Removed unused imports for EImages, ESizes, ERoundedContainer, etc.

class AnalyzerDialog extends StatefulWidget {
  final void Function(File image) onImageCaptured;

  const AnalyzerDialog({super.key, required this.onImageCaptured});

  @override
  State<AnalyzerDialog> createState() => _AnalyzerDialogState();
}

class _AnalyzerDialogState extends State<AnalyzerDialog> {
  // Removed _isAnalyzing as it belongs to the parent widget (EAnalyserContainer)
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  // Removed File? capturedImage; as the image is returned via callback and the dialog closes.

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      // Ensure we find the front camera
      final front = cameras.firstWhere(
            (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _cameraController = CameraController(front, ResolutionPreset.medium, enableAudio: false);
      await _cameraController.initialize();
      if (mounted) setState(() => _isCameraInitialized = true);
    } catch (e) {
      debugPrint("Error initializing camera: $e");
      // Optionally show an error message to the user
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _captureImage() async {
    if (!_isCameraInitialized || _isCapturing) return;

    setState(() => _isCapturing = true);
    try {
      final XFile file = await _cameraController.takePicture();
      // 1. Pass the captured image back to the parent widget
      widget.onImageCaptured(File(file.path));
      // 2. Close the dialog
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Error capturing: $e");
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      // Use a full-screen container for the camera view
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: EColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Position your face',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: EColors.dermDark,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: EColors.dermDark),
                ),
              ],
            ),
          ),

          // Camera preview area with head outline and capture button
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(0), // Removed margin for a better full-screen effect
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Camera Preview
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: _isCameraInitialized
                        ? CameraPreview(_cameraController) // Display the live camera feed
                        : Center(
                      child: CircularProgressIndicator(
                        color: EColors.dermPink,
                      ),
                    ),
                  ),

                  // 2. Head Guide Overlay and Capture Button
                  if (_isCameraInitialized)
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Head guide overlay
                          Expanded(
                            child: Center(
                              child: Container(
                                width: 280,
                                height: 380,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: EColors.dermPink,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(200), // Oval/Circle shape guide
                                ),
                                // Use a semi-transparent background to focus on the face
                                child: Container(
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ),
                            ),
                          ),
                          // Capture Button
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: IconButton(
                              onPressed: _isCapturing ? null : _captureImage,
                              icon: Icon(
                                _isCapturing ? Icons.hourglass_empty : Icons.camera_alt_rounded,
                                size: 80,
                                color: EColors.dermPink,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.9),
                                padding: const EdgeInsets.all(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Removed Analysis button and Recommended products section
        ],
      ),
    );
  }

// Removed _buildRecommendedProduct() and _analyzeSkin() as they are no longer needed here
}