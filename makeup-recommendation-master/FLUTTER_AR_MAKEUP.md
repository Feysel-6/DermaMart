# Flutter AR Makeup Overlay Implementation Guide

This guide shows how to implement real-time AR makeup overlay in Flutter using the recommended colors from your API.

## Overview

The original Android app uses:
- **Face Detection**: Google ML Kit Face Detection
- **Face Contours**: Lips, eyes, eyebrows detection
- **Canvas Drawing**: Custom painting with blending modes
- **Real-time Overlay**: Camera preview with makeup overlay

## Flutter Implementation Approach

### Option 1: Using `camera` + `google_mlkit_face_detection` (Recommended)

This is the closest to the original Android implementation.

### Option 2: Using `camera` + `tflite_flutter` with face landmarks

If you need more control over face landmarks.

### Option 3: Using `camera` + `face_detection` package

Simpler but less customizable.

## Required Packages

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  camera: ^0.10.5+5
  google_mlkit_face_detection: ^0.7.0
  http: ^0.13.5
  image_picker: ^0.8.6
```

## Implementation Steps

### Step 1: Setup Camera with Face Detection

```dart
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:ui' as ui;

class ARMakeupPage extends StatefulWidget {
  final Map<String, dynamic> makeupColors;
  
  const ARMakeupPage({required this.makeupColors});
  
  @override
  _ARMakeupPageState createState() => _ARMakeupPageState();
}

class _ARMakeupPageState extends State<ARMakeupPage> {
  CameraController? _cameraController;
  FaceDetector? _faceDetector;
  List<Face> _faces = [];
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeFaceDetector();
  }
  
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
    );
    
    await _cameraController!.initialize();
    
    _cameraController!.startImageStream((CameraImage image) {
      _processImage(image);
    });
    
    setState(() {});
  }
  
  void _initializeFaceDetector() {
    final options = FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: false,
      enableTracking: false,
    );
    _faceDetector = FaceDetector(options: options);
  }
  
  Future<void> _processImage(CameraImage image) async {
    if (_faceDetector == null) return;
    
    final inputImage = _inputImageFromCameraImage(image);
    final faces = await _faceDetector!.processImage(inputImage);
    
    setState(() {
      _faces = faces;
    });
  }
  
  InputImage _inputImageFromCameraImage(CameraImage image) {
    // Convert CameraImage to InputImage
    // Implementation depends on your camera package version
    // See: https://pub.dev/packages/google_mlkit_face_detection
  }
  
  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector?.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          CustomPaint(
            painter: MakeupPainter(
              faces: _faces,
              makeupColors: widget.makeupColors,
              cameraSize: _cameraController!.value.previewSize!,
            ),
            child: Container(),
          ),
        ],
      ),
    );
  }
}
```

### Step 2: Create Custom Painter for Makeup Overlay

```dart
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:ui' as ui;

class MakeupPainter extends CustomPainter {
  final List<Face> faces;
  final Map<String, dynamic> makeupColors;
  final Size cameraSize;
  
  MakeupPainter({
    required this.faces,
    required this.makeupColors,
    required this.cameraSize,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    for (var face in faces) {
      _drawLipstick(canvas, face, size);
      _drawEyeshadow(canvas, face, size);
    }
  }
  
  void _drawLipstick(Canvas canvas, Face face, Size size) {
    // Get lipstick color from API response
    final lipstickColor = Color.fromRGBO(
      makeupColors['lipstick_color'][0],
      makeupColors['lipstick_color'][1],
      makeupColors['lipstick_color'][2],
      1.0,
    );
    
    // Get lip contours
    final upperLipTop = face.getContour(FaceContourType.upperLipTop);
    final lowerLipBottom = face.getContour(FaceContourType.lowerLipBottom);
    
    if (upperLipTop == null || lowerLipBottom == null) return;
    
    // Create path for lips
    final path = Path();
    
    // Draw lower lip
    final lowerPoints = lowerLipBottom.points;
    if (lowerPoints.isNotEmpty) {
      path.moveTo(
        _translateX(lowerPoints[0].x, size),
        _translateY(lowerPoints[0].y, size),
      );
      for (var point in lowerPoints) {
        path.lineTo(
          _translateX(point.x, size),
          _translateY(point.y, size),
        );
      }
    }
    
    // Draw upper lip
    final upperPoints = upperLipTop.points;
    if (upperPoints.isNotEmpty) {
      for (var point in upperPoints) {
        path.lineTo(
          _translateX(point.x, size),
          _translateY(point.y, size),
        );
      }
    }
    path.close();
    
    // Draw lipstick with blending
    final paint = Paint()
      ..color = lipstickColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.overlay;
    
    // First layer (more transparent)
    paint.color = lipstickColor.withOpacity(0.5);
    canvas.drawPath(path, paint);
    
    // Second layer (more opaque, smaller)
    paint.color = lipstickColor.withOpacity(0.8);
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawPath(path, paint);
  }
  
  void _drawEyeshadow(Canvas canvas, Face face, Size size) {
    // Get eyeshadow colors
    final outerColor = Color.fromRGBO(
      makeupColors['eyeshadow_outer_color'][0],
      makeupColors['eyeshadow_outer_color'][1],
      makeupColors['eyeshadow_outer_color'][2],
      1.0,
    );
    
    final middleColor = Color.fromRGBO(
      makeupColors['eyeshadow_middle_color'][0],
      makeupColors['eyeshadow_middle_color'][1],
      makeupColors['eyeshadow_middle_color'][2],
      1.0,
    );
    
    final innerColor = Color.fromRGBO(
      makeupColors['eyeshadow_inner_color'][0],
      makeupColors['eyeshadow_inner_color'][1],
      makeupColors['eyeshadow_inner_color'][2],
      1.0,
    );
    
    // Draw for left eye
    final leftEye = face.getContour(FaceContourType.leftEye);
    if (leftEye != null) {
      _drawEyeshadowForEye(canvas, leftEye, outerColor, middleColor, innerColor, size);
    }
    
    // Draw for right eye
    final rightEye = face.getContour(FaceContourType.rightEye);
    if (rightEye != null) {
      _drawEyeshadowForEye(canvas, rightEye, outerColor, middleColor, innerColor, size);
    }
  }
  
  void _drawEyeshadowForEye(
    Canvas canvas,
    FaceContour eyeContour,
    Color outerColor,
    Color middleColor,
    Color innerColor,
    Size size,
  ) {
    final eyePoints = eyeContour.points;
    if (eyePoints.isEmpty) return;
    
    // Create eye shape path
    final eyePath = Path();
    eyePath.moveTo(
      _translateX(eyePoints[0].x, size),
      _translateY(eyePoints[0].y, size),
    );
    for (var point in eyePoints) {
      eyePath.lineTo(
        _translateX(point.x, size),
        _translateY(point.y, size),
      );
    }
    eyePath.close();
    
    // Create larger shadow area (extends above eye)
    final shadowPath = Path();
    final eyeBounds = eyePath.getBounds();
    
    // Extend upward from eye (simplified - you can make this more sophisticated)
    shadowPath.addPath(eyePath, Offset.zero);
    shadowPath.addRect(Rect.fromLTWH(
      eyeBounds.left,
      eyeBounds.top - eyeBounds.height * 0.5,
      eyeBounds.width,
      eyeBounds.height * 1.5,
    ));
    
    // Create gradient for eyeshadow (outer -> middle -> inner)
    final gradient = ui.Gradient.linear(
      Offset(eyeBounds.left, eyeBounds.center.dy),
      Offset(eyeBounds.right, eyeBounds.center.dy),
      [outerColor, middleColor, innerColor],
      [0.0, 0.5, 1.0],
    );
    
    final paint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.overlay
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15);
    
    canvas.drawPath(shadowPath, paint);
  }
  
  double _translateX(double x, Size size) {
    // Convert camera coordinates to screen coordinates
    return x * size.width / cameraSize.width;
  }
  
  double _translateY(double y, Size size) {
    // Convert camera coordinates to screen coordinates
    return y * size.height / cameraSize.height;
  }
  
  @override
  bool shouldRepaint(MakeupPainter oldDelegate) {
    return faces != oldDelegate.faces ||
           makeupColors != oldDelegate.makeupColors;
  }
}
```

### Step 3: Complete Example - Camera Page with AR Makeup

```dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'services/makeup_api_service.dart';

class CameraMakeupPage extends StatefulWidget {
  @override
  _CameraMakeupPageState createState() => _CameraMakeupPageState();
}

class _CameraMakeupPageState extends State<CameraMakeupPage> {
  CameraController? _controller;
  FaceDetector? _faceDetector;
  List<Face> _faces = [];
  Map<String, dynamic>? _makeupColors;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeFaceDetector();
  }
  
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
    );
    
    await _controller!.initialize();
    _controller!.startImageStream(_processCameraImage);
    
    setState(() {});
  }
  
  void _initializeFaceDetector() {
    final options = FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    );
    _faceDetector = FaceDetector(options: options);
  }
  
  Future<void> _processCameraImage(CameraImage image) async {
    if (_faceDetector == null) return;
    
    // Convert CameraImage to InputImage
    // This depends on your camera package version
    // See documentation for exact implementation
    
    final faces = await _faceDetector!.processImage(inputImage);
    
    setState(() {
      _faces = faces;
    });
  }
  
  Future<void> _getMakeupRecommendation() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Capture image
      final image = await _controller!.takePicture();
      
      // Send to API
      final colors = await MakeupApiService.getMakeupRecommendation(
        File(image.path),
      );
      
      setState(() {
        _makeupColors = colors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller!),
          if (_makeupColors != null)
            CustomPaint(
              painter: MakeupPainter(
                faces: _faces,
                makeupColors: _makeupColors!,
                cameraSize: _controller!.value.previewSize!,
              ),
              child: Container(),
            ),
          if (_isLoading)
            Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getMakeupRecommendation,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
  
  @override
  void dispose() {
    _controller?.dispose();
    _faceDetector?.close();
    super.dispose();
  }
}
```

## Key Techniques from Original Android App

### 1. Lipstick Application
- Uses Bezier splines for smooth lip curves
- Applies OVERLAY blend mode for realistic effect
- Two layers: base (more transparent) + overlay (more opaque)
- Blur filter for soft edges

### 2. Eyeshadow Application
- Creates gradient from outer → middle → inner colors
- Extends shadow area above eye contour
- Uses LinearGradient for smooth color transition
- Blur mask filter for blending

### 3. Face Contour Detection
- Uses ML Kit face contours (lips, eyes, eyebrows)
- Converts camera coordinates to screen coordinates
- Applies transformations based on face angle

## Advanced Features

### Blending Modes
```dart
// Try different blend modes for different effects
BlendMode.overlay  // Most realistic for makeup
BlendMode.colorBurn  // More intense
BlendMode.softLight  // Softer effect
BlendMode.multiply  // Darker, more dramatic
```

### Opacity Control
```dart
// Adjust opacity for intensity
paint.color = lipstickColor.withOpacity(0.6);  // Light makeup
paint.color = lipstickColor.withOpacity(0.9);  // Heavy makeup
```

### Blur Effects
```dart
// Adjust blur for different effects
MaskFilter.blur(BlurStyle.normal, 10)  // Soft edges
MaskFilter.blur(BlurStyle.normal, 20)  // Very soft
```

## Performance Tips

1. **Process frames at lower rate**: Don't process every frame
2. **Use smaller resolution**: High resolution may be slow
3. **Cache face detection**: Reuse detection results
4. **Optimize painting**: Only repaint when faces change

## Alternative: Using Existing Packages

Consider using:
- `camera_ml_kit` - Combines camera + ML Kit
- `face_recognition` - If you need more control
- `tflite_flutter` - For custom models

## Testing

1. Test with good lighting
2. Test with different face angles
3. Verify colors match API recommendations
4. Test performance on real devices

## Next Steps

1. Implement camera + face detection
2. Create custom painter for makeup overlay
3. Connect to your API for color recommendations
4. Test and refine the visual effects

Your API is ready - now you can apply the colors in real-time AR! 🎉


