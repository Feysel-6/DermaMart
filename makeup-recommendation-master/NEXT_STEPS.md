# ✅ Server is Running! Next Steps

## Current Status

✅ **Server is running successfully!**
- URL: http://localhost:8080 (or http://192.168.0.123:8080 from other devices)
- Pipeline loaded: ✅
- Ready to accept requests!

## Step 1: Test the API

### Test Health Endpoint

Open a **new terminal** (keep the server running in the first one) and run:

```powershell
# Test health endpoint
curl http://localhost:8080/health

# Or using Python
python -c "import requests; print(requests.get('http://localhost:8080/health').json())"
```

**Expected output:**
```json
{
  "status": "healthy",
  "pipeline_loaded": true,
  "device": "cpu"
}
```

### Test with a Face Image

You need a face image (JPG/PNG) to test the makeup recommendation:

```powershell
# Using curl (replace with your image path)
curl -X POST -F "img=@C:\path\to\your\face_image.jpg" http://localhost:8080/

# Or create a test script
```

**Create `test_quick.py`:**

```python
import requests
import json

# Test health
print("Testing health endpoint...")
health = requests.get("http://localhost:8080/health").json()
print(f"✅ Health: {health['status']}, Pipeline: {health['pipeline_loaded']}")

# Test with image (replace path)
image_path = r"C:\path\to\your\face_image.jpg"  # CHANGE THIS!

print(f"\nTesting recommendation with: {image_path}")
with open(image_path, 'rb') as f:
    files = {'img': ('face.jpg', f, 'image/jpeg')}
    response = requests.post('http://localhost:8080/', files=files)

if response.status_code == 200:
    result = response.json()
    print("\n✅ Success! Recommended colors:")
    print(f"  💄 Lipstick: RGB{result['lipstick_color']}")
    print(f"  👁️  Eyeshadow Outer: RGB{result['eyeshadow_outer_color']}")
    print(f"  👁️  Eyeshadow Middle: RGB{result['eyeshadow_middle_color']}")
    print(f"  👁️  Eyeshadow Inner: RGB{result['eyeshadow_inner_color']}")
else:
    print(f"❌ Error: {response.status_code}")
    print(response.text)
```

## Step 2: Find Your Computer's IP Address

For Flutter integration, you'll need your computer's IP address:

```powershell
ipconfig
```

Look for **IPv4 Address** under your active network adapter (usually Wi-Fi or Ethernet). 
From your server output, it's: **192.168.0.123**

## Step 3: Integrate with Flutter

Now that the API is working, you can integrate it with your Flutter app!

### Update Flutter Code

1. **Add HTTP dependency** to `pubspec.yaml`:
```yaml
dependencies:
  http: ^0.13.5
  image_picker: ^0.8.6
```

2. **Create API service** (`lib/services/makeup_api_service.dart`):
```dart
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MakeupApiService {
  // Update this with your server IP
  static const String baseUrl = 'http://192.168.0.123:8080';
  
  static Future<Map<String, dynamic>> getMakeupRecommendation(File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/'));
    request.files.add(
      await http.MultipartFile.fromPath('img', imageFile.path),
    );
    
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed: ${response.statusCode}');
    }
  }
}
```

3. **Use in your Flutter UI**:
```dart
// In your widget
File? pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
if (pickedImage != null) {
  final result = await MakeupApiService.getMakeupRecommendation(File(pickedImage.path));
  // result contains: lipstick_color, eyeshadow_outer_color, etc.
  print('Lipstick: ${result['lipstick_color']}');
}
```

## Step 4: Important Notes

### Server IP for Flutter
- **Local testing**: Use `http://localhost:8080` (if testing on same device)
- **Network testing**: Use `http://192.168.0.123:8080` (from your Flutter app)
- **Make sure**: Flutter app and server are on the same Wi-Fi network

### Port Firewall
Windows Firewall may block port 8080. If Flutter can't connect:
1. Open Windows Firewall settings
2. Allow port 8080 or add Python to firewall exceptions

### Testing Tips
- Use clear, front-facing face photos
- Good lighting works best
- Processing takes 2-5 seconds on CPU
- Server must be running when Flutter app calls it

## Complete Example Flow

1. ✅ **Server running** (you're here!)
2. ✅ **Test API** with a face image
3. ✅ **Get IP address** (192.168.0.123)
4. ✅ **Update Flutter code** with IP
5. ✅ **Test from Flutter app**

## Troubleshooting

### Can't connect from Flutter?
- Check server is running
- Verify IP address is correct
- Check firewall settings
- Make sure devices are on same network

### API returns errors?
- Check image format (JPG/PNG)
- Ensure face is clearly visible
- Check server logs for errors

### Need help?
- See `FLUTTER_INTEGRATION.md` for complete code examples
- Check server logs for error messages

---

**You're all set!** The server is working. Now test it with an image, then integrate with your Flutter app! 🎉

