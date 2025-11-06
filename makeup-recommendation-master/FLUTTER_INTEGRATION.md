# Flutter Integration Guide for Makeup Recommendation API

This guide explains how to integrate the makeup recommendation ML/AI functionality into your Flutter app.

## Overview

The core ML/AI functionality is provided as a REST API server that you can run separately from your Flutter app. Your Flutter app sends face images to the API and receives recommended makeup colors.

## Architecture

```
┌─────────────┐         HTTP POST         ┌──────────────┐
│             │  ───────────────────────> │              │
│ Flutter App │                           │ Python API   │
│             │  <─────────────────────── │ Server       │
└─────────────┘      JSON Response        └──────────────┘
```

## Step 1: Setup the API Server

### Option A: Using Conda (Recommended for ML dependencies)

```bash
# Create conda environment
conda create -n makeup-api python=3.8.5
conda activate makeup-api

# Install PyTorch (CPU version)
conda install pytorch==1.7.0 torchvision==0.8.1 cpuonly -c pytorch

# Install other dependencies
pip install -r requirements.txt

# Run the server
python standalone_server.py --host 0.0.0.0 --port 8080
```

### Option B: Using pip only (simpler, but may have issues with dlib)

```bash
pip install -r requirements.txt
python standalone_server.py --host 0.0.0.0 --port 8080
```

**Note:** The server requires all model files to be present:
- `automakeup/automakeup/resources/ganette.pkl`
- `automakeup/automakeup/resources/ganette_x_scaler.pkl`
- `automakeup/automakeup/resources/ganette_y_scaler.pkl`
- `third_party/mtcnn/mtcnn/resources/mtcnn.pt`
- `third_party/facenet/facenet/resources/inception_resnet_v1_vggface2.pt`
- `third_party/faceparsing/faceparsing/resources/bisenet.pth`

## Step 2: Flutter Implementation

### Add HTTP dependencies to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.5
  image_picker: ^0.8.6
  # Add other dependencies as needed
```

### Create API Service (`lib/services/makeup_api_service.dart`):

```dart
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MakeupApiService {
  // Update this with your server IP/URL
  static const String baseUrl = 'http://YOUR_SERVER_IP:8080';
  
  /// Send face image and get makeup recommendations
  /// 
  /// [imageFile] - File object containing the face image
  /// Returns JSON map with recommended colors
  static Future<Map<String, dynamic>> getMakeupRecommendation(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/'));
      request.files.add(
        await http.MultipartFile.fromPath('img', imageFile.path),
      );
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get recommendation: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error calling API: $e');
    }
  }
  
  /// Check if API server is healthy
  static Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
```

### Create Model Class (`lib/models/makeup_recommendation.dart`):

```dart
import 'package:flutter/material.dart';

class MakeupRecommendation {
  final List<int> skinColor;
  final List<int> hairColor;
  final List<int> lipsColor;
  final List<int> eyesColor;
  final List<int> lipstickColor;
  final List<int> eyeshadowOuterColor;
  final List<int> eyeshadowMiddleColor;
  final List<int> eyeshadowInnerColor;
  
  MakeupRecommendation({
    required this.skinColor,
    required this.hairColor,
    required this.lipsColor,
    required this.eyesColor,
    required this.lipstickColor,
    required this.eyeshadowOuterColor,
    required this.eyeshadowMiddleColor,
    required this.eyeshadowInnerColor,
  });
  
  factory MakeupRecommendation.fromJson(Map<String, dynamic> json) {
    return MakeupRecommendation(
      skinColor: List<int>.from(json['skin_color']),
      hairColor: List<int>.from(json['hair_color']),
      lipsColor: List<int>.from(json['lips_color']),
      eyesColor: List<int>.from(json['eyes_color']),
      lipstickColor: List<int>.from(json['lipstick_color']),
      eyeshadowOuterColor: List<int>.from(json['eyeshadow_outer_color']),
      eyeshadowMiddleColor: List<int>.from(json['eyeshadow_middle_color']),
      eyeshadowInnerColor: List<int>.from(json['eyeshadow_inner_color']),
    );
  }
  
  /// Convert RGB list to Flutter Color
  Color get lipstickColorFlutter => Color.fromRGBO(
    lipstickColor[0],
    lipstickColor[1],
    lipstickColor[2],
    1.0,
  );
  
  Color get eyeshadowOuterColorFlutter => Color.fromRGBO(
    eyeshadowOuterColor[0],
    eyeshadowOuterColor[1],
    eyeshadowOuterColor[2],
    1.0,
  );
  
  Color get eyeshadowMiddleColorFlutter => Color.fromRGBO(
    eyeshadowMiddleColor[0],
    eyeshadowMiddleColor[1],
    eyeshadowMiddleColor[2],
    1.0,
  );
  
  Color get eyeshadowInnerColorFlutter => Color.fromRGBO(
    eyeshadowInnerColor[0],
    eyeshadowInnerColor[1],
    eyeshadowInnerColor[2],
    1.0,
  );
}
```

### Example Usage in Flutter Widget:

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'services/makeup_api_service.dart';
import 'models/makeup_recommendation.dart';

class MakeupRecommendationPage extends StatefulWidget {
  @override
  _MakeupRecommendationPageState createState() => _MakeupRecommendationPageState();
}

class _MakeupRecommendationPageState extends State<MakeupRecommendationPage> {
  File? _image;
  MakeupRecommendation? _recommendation;
  bool _isLoading = false;
  String? _error;
  
  final ImagePicker _picker = ImagePicker();
  
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _recommendation = null;
        _error = null;
      });
      await _getRecommendation();
    }
  }
  
  Future<void> _getRecommendation() async {
    if (_image == null) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final data = await MakeupApiService.getMakeupRecommendation(_image!);
      setState(() {
        _recommendation = MakeupRecommendation.fromJson(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Makeup Recommendation')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Take Photo'),
            ),
            SizedBox(height: 20),
            if (_image != null) ...[
              Image.file(_image!, height: 200),
              SizedBox(height: 20),
            ],
            if (_isLoading)
              CircularProgressIndicator()
            else if (_error != null)
              Text('Error: $_error', style: TextStyle(color: Colors.red))
            else if (_recommendation != null) ...[
              Text('Recommended Colors:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildColorRow('Lipstick', _recommendation!.lipstickColorFlutter),
              SizedBox(height: 5),
              _buildColorRow('Eyeshadow Outer', _recommendation!.eyeshadowOuterColorFlutter),
              SizedBox(height: 5),
              _buildColorRow('Eyeshadow Middle', _recommendation!.eyeshadowMiddleColorFlutter),
              SizedBox(height: 5),
              _buildColorRow('Eyeshadow Inner', _recommendation!.eyeshadowInnerColorFlutter),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildColorRow(String label, Color color) {
    return Row(
      children: [
        Text(label + ': '),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
        ),
        SizedBox(width: 10),
        Text('RGB(${color.red}, ${color.green}, ${color.blue})'),
      ],
    );
  }
}
```

## API Response Format

The API returns JSON with the following structure:

```json
{
  "skin_color": [r, g, b],
  "hair_color": [r, g, b],
  "lips_color": [r, g, b],
  "eyes_color": [r, g, b],
  "lipstick_color": [r, g, b],
  "eyeshadow_outer_color": [r, g, b],
  "eyeshadow_middle_color": [r, g, b],
  "eyeshadow_inner_color": [r, g, b]
}
```

All color values are RGB integers in the range [0, 255].

## Deployment Options

### Local Development
- Run the server on your local machine
- Use your machine's IP address in Flutter app
- Make sure both devices are on the same network

### Production Options

1. **Cloud Server** (AWS EC2, Google Cloud, Azure)
   - Deploy the Python server on a VM
   - Use the VM's public IP address
   - Consider using gunicorn for production: `gunicorn -w 4 -b 0.0.0.0:8080 standalone_server:app`

2. **Docker Container** (Recommended)
   - Create a Dockerfile for the Python server
   - Deploy to cloud container services (AWS ECS, Google Cloud Run, etc.)

3. **Serverless** (AWS Lambda, Google Cloud Functions)
   - Requires adaptation of the code for serverless architecture

## Troubleshooting

### Server Issues
- **Model files not found**: Ensure all model files are in the correct directories
- **CUDA errors**: Use `--device cpu` flag if GPU is not available
- **dlib installation issues**: Use conda instead of pip for dlib: `conda install -c conda-forge dlib`

### Flutter Issues
- **Network errors**: Check server URL and ensure server is running
- **CORS errors**: The standalone server includes CORS support
- **Image format**: Ensure images are valid JPEG/PNG formats

### Performance
- **Slow processing**: Consider using GPU if available
- **Memory issues**: Reduce image size before sending to API
- **Timeout**: Increase timeout duration in HTTP client

## Notes

- The original project uses Bazel build system, but the standalone server doesn't require it
- Model files are large (~100MB+ total), ensure they're present
- Processing time: ~2-5 seconds per image (CPU), ~0.5-1 second (GPU)
- The API is stateless - each request is independent

