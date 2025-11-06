import requests
import json

try:
    print("Testing health endpoint...")
    response = requests.get("http://localhost:8080/health", timeout=5)
    print(f"Status Code: {response.status_code}")
    
    if response.status_code == 200:
        data = response.json()
        print("\n[SUCCESS] Health Check Passed!")
        print(json.dumps(data, indent=2))
    else:
        print(f"\n[ERROR] Health check failed: {response.status_code}")
        print(response.text)
except Exception as e:
    print(f"[ERROR] {e}")
    print("\nMake sure the server is running in another terminal!")
