import requests
import json

# CHANGE THIS to your face image path
image_path = r"C:\Users\smrc\Documents\dryy.jpg"  # Update this path!

print(f"Testing makeup recommendation with image: {image_path}")
print("=" * 60)

try:
    with open(image_path, 'rb') as f:
        files = {'img': ('dryy.jpg', f, 'image/jpg')}
        print("Sending request to server...")
        response = requests.post('http://localhost:8080/', files=files, timeout=30)
    
    if response.status_code == 200:
        result = response.json()s
        print("\n[SUCCESS] Makeup Recommendation Received!")
        print("=" * 60)
        print("\nRecommended Makeup Colors:")
        print(f"  Lipstick:        RGB{result['lipstick_color']}")
        print(f"  Eyeshadow Outer: RGB{result['eyeshadow_outer_color']}")
        print(f"  Eyeshadow Middle: RGB{result['eyeshadow_middle_color']}")
        print(f"  Eyeshadow Inner: RGB{result['eyeshadow_inner_color']}")
        print("\nDetected Features:")
        print(f"  Skin: RGB{result['skin_color']}")
        print(f"  Hair: RGB{result['hair_color']}")
        print(f"  Lips: RGB{result['lips_color']}")
        print(f"  Eyes: RGB{result['eyes_color']}")
        print("\n" + "=" * 60)
        print("API is working correctly! Ready for Flutter integration.")
    else:
        print(f"\n[ERROR] Status Code: {response.status_code}")
        print("Response:", response.text)
        
except FileNotFoundError:
    print(f"\n[ERROR] Image file not found: {image_path}")
    print("\nPlease:")
    print("1. Update the 'image_path' variable in this script")
    print("2. Use a valid path to a face image (JPG or PNG)")
    print("3. Make sure the image shows a clear face")
    
except requests.exceptions.ConnectionError:
    print("\n[ERROR] Cannot connect to server!")
    print("Make sure the server is running:")
    print("  python standalone_server.py --host 0.0.0.0 --port 8080 --device cpu")
    
except Exception as e:
    print(f"\n[ERROR] {e}")
    import traceback
    traceback.print_exc()

