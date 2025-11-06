# Feature Extraction Process - How Makeup Recommendations Work

## Overview

The system extracts **4 key facial features** before making makeup recommendations. These features are **RGB color values** extracted from specific facial regions.

## Step-by-Step Feature Extraction Process

### Step 1: Face Detection
**Location**: `automakeup/automakeup/face/bounding.py`
- Uses **MTCNN** to detect face in image
- Finds bounding box around face
- Extracts face region (512x512 pixels)

### Step 2: Face Segmentation
**Location**: `automakeup/automakeup/feature/extract.py` (line 41-46)
- Uses **Face Parsing** (BiSeNet model) to segment face into regions:
  - Skin region
  - Hair region
  - Lips region (upper + lower lip)
  - Eyes region (left + right eye)

### Step 3: Color Extraction
**Location**: `automakeup/automakeup/feature/extract.py` (line 24-96)

The system extracts **RGB color values** from each facial region:

#### Feature 1: Skin Color
**Method**: `_skin()` (line 67-68)
- Extracts color from **skin region**
- Uses **Geometric Median Color** extraction
- Returns: `[skin_r, skin_g, skin_b]`
- **Purpose**: Determines skin tone to match makeup colors

**Example**: `[193, 150, 122]` = Light/medium skin tone

#### Feature 2: Hair Color
**Method**: `_hair()` (line 70-71)
- Extracts color from **hair region**
- Uses **Geometric Median Color** extraction
- Returns: `[hair_r, hair_g, hair_b]`
- **Purpose**: Complements makeup with hair color

**Example**: `[62, 43, 33]` = Dark brown/black hair

#### Feature 3: Lips Color
**Method**: `_lips()` (line 73-74)
- Extracts color from **lip region** (both upper and lower lip)
- Uses **Geometric Median Color** extraction
- Returns: `[lips_r, lips_g, lips_b]`
- **Purpose**: Base color for lipstick recommendations

**Example**: `[173, 97, 89]` = Natural lip color

#### Feature 4: Eyes Color (Iris Color)
**Method**: `_eyes()` (line 76-81)
- Extracts color from **iris** (not whole eye)
- First crops to biggest eye
- Uses **ClusteringIrisShapeExtractor** to find iris
- Extracts color from iris region only
- Returns: `[eyes_r, eyes_g, eyes_b]`
- **Purpose**: Complements eyeshadow colors

**Example**: `[80, 60, 50]` = Brown eye color
- If not detected: `[-1, -1, -1]`

## Complete Feature Vector

The system extracts **12 values total** (4 features × 3 RGB channels):

```
Features = [
    skin_r, skin_g, skin_b,      # Feature 1: Skin color
    hair_r, hair_g, hair_b,       # Feature 2: Hair color
    lips_r, lips_g, lips_b,       # Feature 3: Lips color
    eyes_r, eyes_g, eyes_b        # Feature 4: Eyes/Iris color
]
```

**Example feature vector**:
```
[193, 150, 122,    # Skin: RGB
 62,  43,  33,     # Hair: RGB
173,  97,  89,     # Lips: RGB
-1,  -1,  -1]      # Eyes: Not detected
```

## How These Features Are Used

### 1. Input to ML Model
**Location**: `automakeup/automakeup/encoded_recommendation.py` (line 36-39)

```python
# Features are preprocessed
y = self.y_scaler.transform(self.preprocess(features))

# ML model generates makeup colors based on features
x = self.model.sample(y)

# Postprocess to get final RGB colors
recommended_colors = self.postprocess(self.x_scaler.inverse_transform(x))
```

### 2. Feature → Recommendation Mapping

The trained **Ganette model** learns patterns like:
- **Light skin** → Lighter makeup colors
- **Dark hair** → Contrasting makeup
- **Warm skin tones** → Warm makeup colors
- **Cool skin tones** → Cool makeup colors

## Technical Details

### Color Extraction Method: Geometric Median
**Why**: More robust than average color
- Resistant to outliers (shadows, highlights)
- Better represents dominant color
- Location: `imagine/color/extract.py`

### Face Parsing: BiSeNet Model
**What**: Semantic segmentation of face
- Segments face into different regions
- Identifies skin, hair, lips, eyes separately
- Location: `third_party/faceparsing/`

### Iris Detection: Clustering Method
**Why Special**: Eyes contain iris + whites + lashes
- Clusters pixels to find iris region
- Removes eye whites and lashes
- Only extracts iris color

## Feature Extraction Code Flow

```
Image Input
    ↓
Face Detection (MTCNN)
    ↓
Face Extraction (512x512)
    ↓
Face Parsing (BiSeNet) → Segmentation Map
    ↓
┌─────────────────────────────────────┐
│  ColorsFeatureExtractor             │
│                                     │
│  1. Skin Region → RGB Color         │
│  2. Hair Region → RGB Color         │
│  3. Lips Region → RGB Color         │
│  4. Iris Region → RGB Color         │
└─────────────────────────────────────┘
    ↓
12 Features (4 × RGB)
    ↓
ML Model (Ganette)
    ↓
Recommended Makeup Colors
```

## Why These Specific Features?

### 1. **Skin Color** 🎨
- **Most important** for makeup matching
- Determines undertone (warm/cool)
- Affects all makeup color choices

### 2. **Hair Color** 💇
- Provides contrast information
- Helps choose complementary colors
- Affects overall color harmony

### 3. **Lips Color** 👄
- Natural lip color base
- Determines lipstick opacity needed
- Affects lipstick color selection

### 4. **Eyes Color** 👁️
- Iris color for eyeshadow matching
- Complements eye color
- Less critical (often not detected)

## Missing Features

If a feature can't be detected:
- Returns `[-1, -1, -1]` (missing value)
- Model still works with available features
- Eyes often not detected (not critical)

## Real Example from Your Test

Based on your test results:
```
Detected Features:
  Skin: RGB(193, 150, 122)  ← Light/medium skin tone
  Hair: RGB(62, 43, 33)     ← Dark brown hair
  Lips: RGB(173, 97, 89)     ← Natural lip color
  Eyes: RGB(-1, -1, -1)      ← Not detected

Generated Recommendations:
  Lipstick: RGB(213, 99, 99)      ← Coral/reddish pink
  Eyeshadow Outer: RGB(78, 43, 47)   ← Dark brown
  Eyeshadow Middle: RGB(141, 85, 76) ← Medium brown
  Eyeshadow Inner: RGB(201, 146, 133) ← Light beige
```

## Summary

The system checks **4 facial features**:

1. ✅ **Skin Color** (RGB) - Most important
2. ✅ **Hair Color** (RGB) - For contrast
3. ✅ **Lips Color** (RGB) - Base for lipstick
4. ⚠️ **Eyes/Iris Color** (RGB) - Optional

These **12 RGB values** (4 features × 3 channels) are fed into the ML model, which generates makeup color recommendations based on learned patterns from training data.

The model was trained on many face images with makeup, learning which colors work best with which skin tones, hair colors, and lip colors!


