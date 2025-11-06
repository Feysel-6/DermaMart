#!/usr/bin/env python3
"""
Simple test script to verify the makeup recommendation API is working
"""

import sys
import requests
import json
from pathlib import Path

def test_health(base_url):
    """Test the health endpoint"""
    print(f"Testing health endpoint at {base_url}/health...")
    try:
        response = requests.get(f"{base_url}/health", timeout=5)
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Health check passed: {json.dumps(data, indent=2)}")
            return True
        else:
            print(f"❌ Health check failed: Status {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Health check failed: {e}")
        return False

def test_recommendation(base_url, image_path):
    """Test the makeup recommendation endpoint"""
    print(f"\nTesting recommendation endpoint with image: {image_path}")
    
    if not Path(image_path).exists():
        print(f"❌ Image file not found: {image_path}")
        return False
    
    try:
        with open(image_path, 'rb') as f:
            files = {'img': (Path(image_path).name, f, 'image/jpeg')}
            response = requests.post(f"{base_url}/", files=files, timeout=30)
        
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Recommendation successful!")
            print(f"\nRecommended Colors:")
            print(f"  Lipstick: RGB{data['lipstick_color']}")
            print(f"  Eyeshadow Outer: RGB{data['eyeshadow_outer_color']}")
            print(f"  Eyeshadow Middle: RGB{data['eyeshadow_middle_color']}")
            print(f"  Eyeshadow Inner: RGB{data['eyeshadow_inner_color']}")
            print(f"\nFull response:")
            print(json.dumps(data, indent=2))
            return True
        else:
            print(f"❌ Recommendation failed: Status {response.status_code}")
            print(f"Response: {response.text}")
            return False
    except Exception as e:
        print(f"❌ Recommendation failed: {e}")
        return False

def main():
    base_url = sys.argv[1] if len(sys.argv) > 1 else "http://localhost:8080"
    image_path = sys.argv[2] if len(sys.argv) > 2 else None
    
    print(f"Testing Makeup Recommendation API at {base_url}\n")
    
    # Test health endpoint
    if not test_health(base_url):
        print("\n⚠️  Server may not be running or health check failed.")
        print("Make sure the server is started with: python standalone_server.py")
        sys.exit(1)
    
    # Test recommendation endpoint if image provided
    if image_path:
        if not test_recommendation(base_url, image_path):
            sys.exit(1)
        print("\n✅ All tests passed!")
    else:
        print("\n⚠️  No image provided for recommendation test.")
        print("Usage: python test_api.py <base_url> <image_path>")
        print("Example: python test_api.py http://localhost:8080 test_face.jpg")

if __name__ == '__main__':
    main()

