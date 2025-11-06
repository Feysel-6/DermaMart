# Recommendation Files Location Guide

## Core Recommendation Files

### 1. Main Recommendation Logic
**Location**: `automakeup/automakeup/recommenders.py`
- Contains `EncodingRecommender` class
- Main function: `recommend(image)` - generates makeup recommendations
- Returns `MakeupResults` with all colors

### 2. ML Model Recommendation
**Location**: `automakeup/automakeup/encoded_recommendation.py`
- Contains `GanetteRecommender` class
- Uses the trained Ganette model to generate colors
- Handles preprocessing/postprocessing

### 3. Pipeline (Orchestrates Everything)
**Location**: `automakeup/automakeup/pipelines.py`
- Contains `GanettePipeline` class
- Combines: Face detection → Feature extraction → Recommendation
- Main entry point: `run(image)` method

### 4. API Endpoint (Server)
**Location**: `standalone_server.py`
- Flask API endpoint: `POST /`
- Receives image, calls pipeline, returns JSON
- Lines 66-132: The recommendation endpoint

## Model Files (Trained Models)

**Location**: `automakeup/automakeup/resources/`

1. **ganette.pkl** - Main ML model (GAN)
2. **ganette_x_scaler.pkl** - Feature scaler
3. **ganette_y_scaler.pkl** - Output scaler

These are loaded in `pipelines.py` lines 49-57.

## How It Works Together

```
Image Input
    ↓
standalone_server.py (API endpoint)
    ↓
GanettePipeline.run() (pipelines.py)
    ↓
EncodingRecommender.recommend() (recommenders.py)
    ↓
├─ Face Detection (MTCNN)
├─ Feature Extraction (ColorsFeatureExtractor)
└─ GanetteRecommender.recommend() (encoded_recommendation.py)
    ↓
Uses ganette.pkl model
    ↓
Returns MakeupResults with colors
```

## Quick Reference

### To See Recommendation Code:
```bash
# Main recommendation logic
automakeup/automakeup/recommenders.py

# ML model usage
automakeup/automakeup/encoded_recommendation.py

# Full pipeline
automakeup/automakeup/pipelines.py

# API endpoint
standalone_server.py (lines 66-132)
```

### To See Model Files:
```bash
automakeup/automakeup/resources/
├── ganette.pkl          # Main model
├── ganette_x_scaler.pkl # Input scaler
└── ganette_y_scaler.pkl # Output scaler
```

### To Test Recommendations:
```bash
# Test the API
python test_image.py

# Or use curl
curl -X POST -F "img=@image.jpg" http://localhost:8080/
```

## File Structure

```
makeup-recommendation-master/
├── standalone_server.py          ← API endpoint (recommendation API)
├── automakeup/
│   └── automakeup/
│       ├── recommenders.py        ← Main recommendation logic
│       ├── encoded_recommendation.py ← ML model recommendation
│       ├── pipelines.py           ← Full pipeline
│       └── resources/
│           ├── ganette.pkl        ← Trained model
│           ├── ganette_x_scaler.pkl
│           └── ganette_y_scaler.pkl
└── test_image.py                  ← Test script
```

## Key Functions

### Getting Recommendations:

1. **Via API** (Recommended):
   ```python
   # standalone_server.py line 110
   result = pipeline.run(img_rgb)
   ```

2. **Direct Python**:
   ```python
   from automakeup.pipelines import GanettePipeline
   pipeline = GanettePipeline(device='cpu')
   result = pipeline.run(image)
   ```

3. **From Recommender**:
   ```python
   from automakeup.recommenders import EncodingRecommender
   result = recommender.recommend(image)
   ```

## What Each File Does

| File | Purpose |
|------|---------|
| `recommenders.py` | Main recommendation interface |
| `encoded_recommendation.py` | Uses ML model to generate colors |
| `pipelines.py` | Orchestrates face detection → recommendation |
| `standalone_server.py` | API endpoint to get recommendations |
| `ganette.pkl` | Trained neural network model |
| `test_image.py` | Test script for recommendations |

## Most Important Files

1. **`standalone_server.py`** - Your API endpoint (what Flutter calls)
2. **`automakeup/automakeup/pipelines.py`** - Core recommendation pipeline
3. **`automakeup/automakeup/recommenders.py`** - Recommendation logic
4. **`automakeup/automakeup/resources/ganette.pkl`** - The trained model

These are the files that generate your makeup recommendations! 🎨


