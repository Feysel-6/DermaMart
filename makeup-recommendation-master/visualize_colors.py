import requests
import json
from pathlib import Path

def visualize_colors(result):
    """Visualize the recommended makeup colors"""
    print("\n" + "=" * 70)
    print("COLOR VISUALIZATION")
    print("=" * 70)
    
    # Helper function to create RGB visualization
    def rgb_to_hex(rgb):
        """Convert RGB list to hex color"""
        r, g, b = [max(0, min(255, int(c))) for c in rgb]
        return f"#{r:02x}{g:02x}{b:02x}"
    
    def print_color_box(name, rgb):
        """Print a color with its RGB values"""
        if rgb == [-1, -1, -1]:
            print(f"  {name:20} RGB{rgb} (Not detected)")
            return
        
        hex_color = rgb_to_hex(rgb)
        r, g, b = [max(0, min(255, int(c))) for c in rgb]
        
        # Print color name and values
        print(f"  {name:20} RGB({r:3d}, {g:3d}, {b:3d}) {hex_color}")
    
    print("\nRECOMMENDED MAKEUP COLORS:")
    print_color_box("Lipstick", result['lipstick_color'])
    print_color_box("Eyeshadow Outer", result['eyeshadow_outer_color'])
    print_color_box("Eyeshadow Middle", result['eyeshadow_middle_color'])
    print_color_box("Eyeshadow Inner", result['eyeshadow_inner_color'])
    
    print("\nDETECTED FEATURES:")
    print_color_box("Skin", result['skin_color'])
    print_color_box("Hair", result['hair_color'])
    print_color_box("Lips", result['lips_color'])
    print_color_box("Eyes", result['eyes_color'])
    
    print("\n" + "=" * 70)
    print("VALIDATION CHECKLIST:")
    print("=" * 70)
    
    # Validation checks
    checks = []
    
    # Check if colors are valid RGB (0-255)
    all_colors = [
        result['lipstick_color'],
        result['eyeshadow_outer_color'],
        result['eyeshadow_middle_color'],
        result['eyeshadow_inner_color']
    ]
    
    valid_colors = True
    for color in all_colors:
        if not all(0 <= c <= 255 for c in color):
            valid_colors = False
            break
    
    checks.append(("Colors are valid RGB values", valid_colors))
    
    # Check if eyeshadow progression makes sense (outer darker than inner)
    outer = result['eyeshadow_outer_color']
    inner = result['eyeshadow_inner_color']
    if outer != [-1, -1, -1] and inner != [-1, -1, -1]:
        # Calculate brightness (average of RGB)
        outer_brightness = sum(outer) / 3
        inner_brightness = sum(inner) / 3
        progression_ok = outer_brightness < inner_brightness
        checks.append(("Eyeshadow progression (outer darker -> inner lighter)", progression_ok))
    else:
        checks.append(("Eyeshadow progression check", False))
    
    # Check if skin color is detected
    skin_detected = result['skin_color'] != [-1, -1, -1]
    checks.append(("Skin color detected", skin_detected))
    
    # Check if hair color is detected
    hair_detected = result['hair_color'] != [-1, -1, -1]
    checks.append(("Hair color detected", hair_detected))
    
    # Check if lips color is detected
    lips_detected = result['lips_color'] != [-1, -1, -1]
    checks.append(("Lips color detected", lips_detected))
    
    for check, result_bool in checks:
        status = "[OK]" if result_bool else "[FAIL]"
        print(f"  {status} {check}")
    
    print("\n" + "=" * 70)
    print("HOW TO VERIFY:")
    print("=" * 70)
    print("1. Visual Check:")
    print("   - Colors should complement the detected skin tone")
    print("   - Lipstick should suit the natural lip color")
    print("   - Eyeshadow should have a logical progression")
    print()
    print("2. Consistency Check:")
    print("   - RGB values should be between 0-255")
    print("   - Colors should not be all black (0,0,0) or all white (255,255,255)")
    print("   - Missing values show as [-1, -1, -1]")
    print()
    print("3. Test with different images:")
    print("   - Try multiple face photos")
    print("   - Compare results for consistency")
    print("   - Results should vary based on detected features")
    print()
    print("4. Color Preview:")
    print("   - Copy the hex colors (e.g., #D56363)")
    print("   - Paste into an online color picker to see actual colors")
    print("   - Or use a design tool to preview the makeup look")
    
    return checks

if __name__ == '__main__':
    # You can test with a direct result or call the API
    print("Color Visualization Tool")
    print("=" * 70)
    
    # Example: Test with a result
    test_result = {
        "skin_color": [193, 150, 122],
        "hair_color": [62, 43, 33],
        "lips_color": [173, 97, 89],
        "eyes_color": [-1, -1, -1],
        "lipstick_color": [213, 99, 99],
        "eyeshadow_outer_color": [78, 43, 47],
        "eyeshadow_middle_color": [141, 85, 76],
        "eyeshadow_inner_color": [201, 146, 133]
    }
    
    visualize_colors(test_result)

