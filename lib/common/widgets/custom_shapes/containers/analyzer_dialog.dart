import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:get/get.dart';
import '../../../../features/shop/screens/skin_results/analysis_processing.dart';
import '../../../../utlis/constants/colors.dart';

class AnalyzerDialog extends StatefulWidget {
  final void Function(File image) onImageCaptured;

  const AnalyzerDialog({super.key, required this.onImageCaptured});

  @override
  State<AnalyzerDialog> createState() => _AnalyzerDialogState();
}

class _AnalyzerDialogState extends State<AnalyzerDialog> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  FaceDetector? _faceDetector;
  List<Face>? _detectedFaces;
  String _faceStatusMessage = 'Position your face';
  Color _faceStatusColor = Colors.orange;
  bool _isFacePositioned = false;

  @override
  void initState() {
    super.initState();
    _initializeFaceDetector();
    _initializeCamera();
  }

  void _initializeFaceDetector() {
    final options = FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableTracking: true,
      enableContours: true,
      minFaceSize: 0.15,
      performanceMode: FaceDetectorMode.fast,
    );
    _faceDetector = FaceDetector(options: options);
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      
      // Use highest quality settings
      _cameraController = CameraController(
        front,
        ResolutionPreset.ultraHigh,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      
      await _cameraController.initialize();
      
      // Start continuous image stream for face detection
      await _cameraController.startImageStream(_processCameraImage);
      
      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      debugPrint("Error initializing camera: $e");
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize camera: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_faceDetector == null || _isCapturing) return;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;

      final faces = await _faceDetector!.processImage(inputImage);
      
      if (mounted) {
        setState(() {
          _detectedFaces = faces;
          _updateFaceStatus(faces);
        });
      }
    } catch (e) {
      debugPrint("Error processing face detection: $e");
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    try {
      // Convert camera image to bytes
      final allBytes = BytesBuilder();
      for (final Plane plane in image.planes) {
        allBytes.add(plane.bytes);
      }
      final bytes = allBytes.takeBytes();

      final imageRotation = InputImageRotation.rotation0deg;
      
      // Determine format based on camera image format
      final inputImageFormat = Platform.isAndroid 
          ? InputImageFormat.nv21 
          : InputImageFormat.bgra8888;

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: imageRotation,
          format: inputImageFormat,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      return inputImage;
    } catch (e) {
      debugPrint("Error converting camera image: $e");
      return null;
    }
  }

  void _updateFaceStatus(List<Face> faces) {
    if (faces.isEmpty) {
      _faceStatusMessage = 'No face detected';
      _faceStatusColor = Colors.red;
      _isFacePositioned = false;
      return;
    }

    if (faces.length > 1) {
      _faceStatusMessage = 'Only one face please';
      _faceStatusColor = Colors.orange;
      _isFacePositioned = false;
      return;
    }

    final face = faces.first;
    final screenSize = MediaQuery.of(context).size;
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 2;
    
    // Calculate face center position
    final faceCenterX = face.boundingBox.center.dx;
    final faceCenterY = face.boundingBox.center.dy;
    
    // Check if face is centered
    final xOffset = (faceCenterX - centerX).abs();
    final yOffset = (faceCenterY - centerY).abs();
    
    // Check face size (should be reasonable size)
    final faceWidth = face.boundingBox.width;
    final minFaceSize = screenSize.width * 0.25;
    final maxFaceSize = screenSize.width * 0.45;
    
    // Check if face is properly positioned
    final isCentered = xOffset < screenSize.width * 0.15 && yOffset < screenSize.height * 0.15;
    final isGoodSize = faceWidth >= minFaceSize && faceWidth <= maxFaceSize;
    
    if (isCentered && isGoodSize) {
      _faceStatusMessage = 'Perfect! Hold steady';
      _faceStatusColor = Colors.green;
      _isFacePositioned = true;
    } else if (!isCentered) {
      _faceStatusMessage = 'Move face to center';
      _faceStatusColor = Colors.orange;
      _isFacePositioned = false;
    } else if (!isGoodSize) {
      if (faceWidth < minFaceSize) {
        _faceStatusMessage = 'Move closer';
      } else {
        _faceStatusMessage = 'Move further away';
      }
      _faceStatusColor = Colors.orange;
      _isFacePositioned = false;
    } else {
      _faceStatusMessage = 'Adjust position';
      _faceStatusColor = Colors.orange;
      _isFacePositioned = false;
    }
  }

  Future<File?> _cropToHeadshot(File originalImage, Face? face) async {
    try {
      final imageBytes = await originalImage.readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null || face == null) return originalImage;

      // Get face bounding box
      final rect = face.boundingBox;
      
      // Expand crop area to include more of head (1.5x face size)
      final expandFactor = 1.5;
      final cropWidth = (rect.width * expandFactor).toInt();
      final cropHeight = (rect.height * expandFactor).toInt();
      final cropX = (rect.left - (rect.width * (expandFactor - 1) / 2)).toInt();
      final cropY = (rect.top - (rect.height * (expandFactor - 1) / 2)).toInt();

      // Ensure crop coordinates are within image bounds
      final safeX = cropX.clamp(0, image.width - 1);
      final safeY = cropY.clamp(0, image.height - 1);
      final safeWidth = (cropWidth + safeX).clamp(0, image.width) - safeX;
      final safeHeight = (cropHeight + safeY).clamp(0, image.height) - safeY;

      // Crop image
      final cropped = img.copyCrop(
        image,
        x: safeX,
        y: safeY,
        width: safeWidth,
        height: safeHeight,
      );

      // Save cropped image
      final croppedBytes = img.encodeJpg(cropped, quality: 95);
      final croppedFile = File(originalImage.path.replaceAll('.jpg', '_cropped.jpg'));
      await croppedFile.writeAsBytes(croppedBytes);

      return croppedFile;
    } catch (e) {
      debugPrint("Error cropping image: $e");
      return originalImage;
    }
  }

  Future<void> _captureImage() async {
    if (!_isCameraInitialized || _isCapturing || !_isFacePositioned) return;

    setState(() => _isCapturing = true);
    
    // Stop image stream temporarily
    await _cameraController.stopImageStream();
    
    try {
      final XFile file = await _cameraController.takePicture();
      final File imageFile = File(file.path);
      
      // Detect face on the actual captured image for accurate cropping
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final capturedFaces = await _faceDetector!.processImage(inputImage);
      
      // Crop to headshot using face from captured image
      final croppedFile = await _cropToHeadshot(
        imageFile, 
        capturedFaces.isNotEmpty ? capturedFaces.first : null,
      );
      
      if (!mounted) return;
      
      final finalImage = croppedFile ?? imageFile;
      
      // Close dialog
      Navigator.of(context).pop();
      
      // Navigate to processing screen with laser effect
      Get.to(
        () => AnalysisProcessingScreen(imageCaptured: finalImage),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 300),
      );
      
      // Call the callback
      widget.onImageCaptured(finalImage);
    } catch (e) {
      debugPrint("Error capturing: $e");
      // Restart image stream on error
      await _cameraController.startImageStream(_processCameraImage);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to capture image: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isCapturing = false);
      }
    }
  }

  @override
  void dispose() {
    _cameraController.stopImageStream();
    _cameraController.dispose();
    _faceDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: size.width,
        height: size.height,
        color: Colors.black,
        child: Stack(
          children: [
            // Full-screen camera preview
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: _isCameraInitialized
                  ? CameraPreview(_cameraController)
                  : Container(
                      color: Colors.black,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: EColors.dermPink,
                              strokeWidth: 3,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Initializing camera...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),

            // Top gradient overlay with status
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Position Your Face',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withValues(alpha: 0.5),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _faceStatusColor.withValues(alpha: 0.8),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _faceStatusMessage,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withValues(alpha: 0.5),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _cameraController.stopImageStream();
                                Navigator.of(context).pop();
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Static head shape guide overlay
            if (_isCameraInitialized)
              Positioned.fill(
                child: Center(
                  child: CustomPaint(
                    painter: StaticHeadShapeGuidePainter(
                      faceDetected: _detectedFaces?.isNotEmpty == true,
                      isPositioned: _isFacePositioned,
                    ),
                    size: Size(
                      size.width * 0.75,
                      size.height * 0.6,
                    ),
                  ),
                ),
              ),

            // Face detection status is shown in the guide color (green/orange)

            // Bottom controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.black.withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Instructions
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Ensure good lighting and hold steady',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Capture button
                      GestureDetector(
                        onTap: _isCapturing || !_isFacePositioned ? null : _captureImage,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isFacePositioned && !_isCapturing
                                ? Colors.white
                                : Colors.grey,
                            border: Border.all(
                              color: _isFacePositioned && !_isCapturing
                                  ? EColors.dermPink
                                  : Colors.grey,
                              width: 4,
                            ),
                            boxShadow: _isFacePositioned && !_isCapturing
                                ? [
                                    BoxShadow(
                                      color: EColors.dermPink.withValues(alpha: 0.5),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ]
                                : null,
                          ),
                          child: _isCapturing
                              ? Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: CircularProgressIndicator(
                                    color: EColors.dermPink,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Icon(
                                  Icons.camera_alt_rounded,
                                  size: 40,
                                  color: _isFacePositioned
                                      ? EColors.dermPink
                                      : Colors.grey,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Static head shape guide (no animation)
class StaticHeadShapeGuidePainter extends CustomPainter {
  final bool faceDetected;
  final bool isPositioned;

  StaticHeadShapeGuidePainter({
    required this.faceDetected,
    required this.isPositioned,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isPositioned ? Colors.green : EColors.dermPink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final path = Path();
    
    // Draw head shape (oval)
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radiusX = size.width / 2 * 0.9;
    final radiusY = size.height / 2 * 0.85;

    path.addOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: radiusX * 1.8,
        height: radiusY * 1.6,
      ),
    );

    canvas.drawPath(path, paint);

    // Add corner indicators
    final cornerPaint = Paint()
      ..color = isPositioned ? Colors.green : EColors.dermPink
      ..style = PaintingStyle.fill;

    final cornerSize = 20.0;
    final corners = [
      Offset(centerX - radiusX - cornerSize, centerY - radiusY * 0.8 - cornerSize),
      Offset(centerX + radiusX, centerY - radiusY * 0.8 - cornerSize),
      Offset(centerX - radiusX - cornerSize, centerY + radiusY * 0.8),
      Offset(centerX + radiusX, centerY + radiusY * 0.8),
    ];

    for (final corner in corners) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(corner.dx, corner.dy, cornerSize, cornerSize),
          const Radius.circular(4),
        ),
        cornerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => 
      oldDelegate is StaticHeadShapeGuidePainter &&
      (oldDelegate.faceDetected != faceDetected || oldDelegate.isPositioned != isPositioned);
}
