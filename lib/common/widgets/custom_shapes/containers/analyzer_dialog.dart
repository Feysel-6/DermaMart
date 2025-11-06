
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:get/get.dart';
import '../../../../features/shop/screens/skin_results/analysis_processing.dart';
import '../../../../utlis/constants/colors.dart';

// Assume StaticHeadShapeGuidePainter is defined elsewhere, as it was in the original context.
class StaticHeadShapeGuidePainter extends CustomPainter {
  final bool faceDetected;
  final bool isPositioned;

  StaticHeadShapeGuidePainter({required this.faceDetected, required this.isPositioned});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = isPositioned ? Colors.green : (faceDetected ? Colors.orange : Colors.white.withOpacity(0.8));

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(200), // Makes it oval
      ));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


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

      _cameraController = CameraController(
        front,
        ResolutionPreset.high, // Using high for better stream performance
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420, // ✅ More efficient for ML
      );

      await _cameraController.initialize();
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

  bool _isDetecting = false;

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;
      final faces = await _faceDetector!.processImage(inputImage);
      if (mounted) setState(() => _detectedFaces = faces);
    } catch (e) {
      debugPrint('Face detection error: $e');
    } finally {
      _isDetecting = false;
    }
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    // This is a common implementation for converting the YUV420_888 planes
    // into the continuous NV21 format expected by ML Kit for most Android devices.
    final allBytes = WriteBuffer();
    for (var plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  InputImageRotation _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        throw Exception('Invalid rotation value: $rotation');
    }
  }

  // ✅ FIXED: Correct rotation logic
  InputImage? _inputImageFromCameraImage(CameraImage image) {
    try {
      // ... (Your existing rotation and metadata logic)
      final camera = _cameraController.description;
      final sensorOrientation = camera.sensorOrientation;

      final imageRotation = _rotationIntToImageRotation(sensorOrientation);

      // Ensure you handle the format correctly. camera package usually gives YUV420.
      final format = InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;

      // 💡 THE FIX IS HERE: Correctly combining the YUV planes
      final bytes = _concatenatePlanes(image.planes); // 👈 Use the correct helper function

      final inputImageData = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: imageRotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow, // bytesPerRow for Y-plane is used for InputImageMetadata
      );

      return InputImage.fromBytes(
        bytes: bytes, // 👈 The correctly combined bytes
        metadata: inputImageData,
      );
    } catch (e) {
      debugPrint("Error converting camera image: $e");
      return null;
    }
  }

  void _updateFaceStatus(List<Face> faces, InputImageMetadata metadata) {
    if (faces.isEmpty) {
      setState(() {
        _faceStatusMessage = 'No face detected';
        _faceStatusColor = Colors.red;
        _isFacePositioned = false;
      });
      return;
    }

    if (faces.length > 1) {
      setState(() {
        _faceStatusMessage = 'Only one face please';
        _faceStatusColor = Colors.orange;
        _isFacePositioned = false;
      });
      return;
    }

    final face = faces.first;
    final imageSize = metadata.size;
    final imageRotation = metadata.rotation;
    
    final isRotated = imageRotation == InputImageRotation.rotation90deg || imageRotation == InputImageRotation.rotation270deg;
    final uprightWidth = isRotated ? imageSize.height : imageSize.width;
    final uprightHeight = isRotated ? imageSize.width : imageSize.height;

    final centerX = uprightWidth / 2;
    final centerY = uprightHeight / 2;

    final faceBox = face.boundingBox;
    final faceCenterX = (faceBox.left + faceBox.right) / 2;
    final faceCenterY = (faceBox.top + faceBox.bottom) / 2;

    final xOffset = (faceCenterX - centerX).abs();
    final yOffset = (faceCenterY - centerY).abs();

    final faceWidth = faceBox.width;
    final minFaceSize = uprightWidth * 0.35;
    final maxFaceSize = uprightWidth * 0.7;

    final isCentered = xOffset < uprightWidth * 0.15 && yOffset < uprightHeight * 0.15;
    final isGoodSize = faceWidth >= minFaceSize && faceWidth <= maxFaceSize;

    if (isCentered && isGoodSize) {
      _faceStatusMessage = 'Perfect! Hold steady';
      _faceStatusColor = Colors.green;
      _isFacePositioned = true;
    } else if (!isCentered) {
      _faceStatusMessage = 'Move face to center';
      _faceStatusColor = Colors.orange;
      _isFacePositioned = false;
    } else if (faceWidth < minFaceSize) {
      _faceStatusMessage = 'Move closer';
      _faceStatusColor = Colors.orange;
      _isFacePositioned = false;
    } else if (faceWidth > maxFaceSize) {
      _faceStatusMessage = 'Move further away';
      _faceStatusColor = Colors.orange;
      _isFacePositioned = false;
    } else {
      _faceStatusMessage = 'Adjust position';
      _faceStatusColor = Colors.orange;
      _isFacePositioned = false;
    }
    setState(() {}); // Update UI with new status
  }

  Future<File?> _cropToHeadshot(File originalImage, Face? face) async {
    try {
      final imageBytes = await originalImage.readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null || face == null) return originalImage;

      final rect = face.boundingBox;
      
      final expandFactor = 1.5;
      final cropWidth = (rect.width * expandFactor).toInt();
      final cropHeight = (rect.height * expandFactor).toInt();
      final cropX = (rect.left - (rect.width * (expandFactor - 1) / 2)).toInt();
      final cropY = (rect.top - (rect.height * (expandFactor - 1) / 2)).toInt();

      final safeX = cropX.clamp(0, image.width - 1);
      final safeY = cropY.clamp(0, image.height - 1);
      final safeWidth = (cropWidth + safeX).clamp(0, image.width) - safeX;
      final safeHeight = (cropHeight + safeY).clamp(0, image.height) - safeY;

      final cropped = img.copyCrop(
        image,
        x: safeX,
        y: safeY,
        width: safeWidth,
        height: safeHeight,
      );

      final croppedBytes = img.encodeJpg(cropped, quality: 95);
      final croppedFile = File(originalImage.path.replaceFirst('.jpg', '_cropped.jpg'));
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
    
    await _cameraController.stopImageStream();
    
    try {
      final XFile file = await _cameraController.takePicture();
      final File imageFile = File(file.path);
      
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final capturedFaces = await _faceDetector!.processImage(inputImage);
      
      final croppedFile = await _cropToHeadshot(
        imageFile, 
        capturedFaces.isNotEmpty ? capturedFaces.first : null,
      );
      
      if (!mounted) return;
      
      final finalImage = croppedFile ?? imageFile;
      
      Navigator.of(context).pop();
      
      Get.to(
        () => AnalysisProcessingScreen(imageCaptured: finalImage),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 300),
      );
      
      widget.onImageCaptured(finalImage);
    } catch (e) {
      debugPrint("Error capturing: $e");
      if (mounted) {
        await _cameraController.startImageStream(_processCameraImage);
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
    _cameraController.stopImageStream().catchError((e) {
      debugPrint("Error stopping stream on dispose: $e");
    });
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
                            const Text(
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
                      Colors.black.withOpacity(0.7),
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
                                  const Text(
                                    'Position Your Face',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black54,
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
                                      color: _faceStatusColor.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _faceStatusMessage,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
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
                      size.height * 0.5,
                    ),
                  ),
                ),
              ),
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
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _captureImage,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isFacePositioned ? Colors.green : Colors.grey,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: _isCapturing 
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Icon(Icons.camera_alt, color: Colors.white, size: 40),
                        ),
                      )
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
