# Quick Reference: Features Checked Before Recommendation

## 4 Facial Features Extracted

### 1. Skin Color (RGB)
- **Region**: All skin areas on face
- **Method**: Geometric median color extraction
- **Purpose**: Determines skin tone and undertone
- **Impact**: Most important - affects all makeup colors

### 2. Hair Color (RGB)
- **Region**: Hair area on face
- **Method**: Geometric median color extraction
- **Purpose**: Provides contrast information
- **Impact**: Helps choose complementary colors

### 3. Lips Color (RGB)
- **Region**: Upper and lower lip
- **Method**: Geometric median color extraction
- **Purpose**: Natural lip color base
- **Impact**: Affects lipstick color selection

### 4. Eyes/Iris Color (RGB)
- **Region**: Iris only (not whites or lashes)
- **Method**: Clustering to find iris region
- **Purpose**: Complements eyeshadow colors
- **Impact**: Optional (often not detected)

## Feature Vector Format

```
[skin_r, skin_g, skin_b,
 hair_r, hair_g, hair_b,
 lips_r, lips_g, lips_b,
 eyes_r, eyes_g, eyes_b]
```

Total: **12 values** (RGB for each of 4 features)

## Code Locations

- **Feature Extraction**: `automakeup/automakeup/feature/extract.py`
- **Face Parsing**: `third_party/faceparsing/` (BiSeNet model)
- **Color Extraction**: `imagine/color/extract.py` (Geometric median)

## How It Works

```
Face Image
    ↓
Face Parsing → Segments into: Skin, Hair, Lips, Eyes
    ↓
Extract RGB Color from Each Region
    ↓
12 Features → ML Model → Recommended Colors
```

## Key Point

The model was trained to learn patterns like:
- "Light skin tones work well with these colors"
- "Dark hair needs these contrast colors"
- "Warm skin undertones suit warm makeup"

All based on these 4 simple color features!


