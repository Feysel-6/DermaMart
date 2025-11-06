# Standalone Makeup Recommendation API

This is a standalone version of the makeup recommendation API that doesn't require Bazel.

## Quick Start

### 1. Install Dependencies

#### Option A: Using Conda (Recommended)

```bash
conda create -n makeup-api python=3.8.5
conda activate makeup-api
conda install pytorch==1.7.0 torchvision==0.8.1 cpuonly -c pytorch
pip install -r requirements.txt
```

#### Option B: Using pip only

```bash
pip install -r requirements.txt
```

**Note:** Installing `dlib` via pip can be problematic. Use conda if you encounter issues:
```bash
conda install -c conda-forge dlib
```

### 2. Verify Model Files

Ensure these files exist:
- `automakeup/automakeup/resources/ganette.pkl`
- `automakeup/automakeup/resources/ganette_x_scaler.pkl`
- `automakeup/automakeup/resources/ganette_y_scaler.pkl`
- `third_party/mtcnn/mtcnn/resources/mtcnn.pt`
- `third_party/facenet/facenet/resources/inception_resnet_v1_vggface2.pt`
- `third_party/faceparsing/faceparsing/resources/bisenet.pth`

### 3. Run the Server

```bash
python standalone_server.py --host 0.0.0.0 --port 8080
```

For CPU-only mode:
```bash
python standalone_server.py --host 0.0.0.0 --port 8080 --device cpu
```

### 4. Test the API

```bash
# Health check
curl http://localhost:8080/health

# Makeup recommendation (replace with your image path)
curl -X POST -F "img=@path/to/face_image.jpg" http://localhost:8080/
```

## API Endpoints

### POST `/`
Get makeup recommendation for a face image.

**Request:**
- Method: POST
- Content-Type: multipart/form-data
- Field: `img` (image file)

**Response:**
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

### GET `/health`
Health check endpoint.

**Response:**
```json
{
  "status": "healthy",
  "pipeline_loaded": true,
  "device": "cpu"
}
```

## Project Status

✅ **Working Components:**
- All model files are present
- Core pipeline implementation is complete
- API server is functional
- Response format matches Android app expectations

⚠️ **Potential Issues:**
- Dependencies are from 2021 (PyTorch 1.7.0, Python 3.8.5)
- May need updates for newer Python versions
- GPU support requires CUDA 11.0 compatible GPU
- dlib installation can be tricky on some systems

## Differences from Original

The original project uses Bazel for building. This standalone version:
- Removes Bazel dependency
- Uses direct Python imports
- Adds Flask-CORS for cross-origin requests
- Simplifies deployment
- Works with any Python environment manager

## Production Deployment

For production, consider using gunicorn:

```bash
pip install gunicorn
gunicorn -w 4 -b 0.0.0.0:8080 standalone_server:app
```

Or use Docker:

```dockerfile
FROM python:3.8.5-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

CMD ["python", "standalone_server.py", "--host", "0.0.0.0", "--port", "8080"]
```

## Troubleshooting

1. **Import errors**: Ensure all Python paths are correct
2. **Model file errors**: Check that all model files are present
3. **CUDA errors**: Use `--device cpu` flag
4. **dlib errors**: Install via conda: `conda install -c conda-forge dlib`

## Integration

See `FLUTTER_INTEGRATION.md` for Flutter integration guide.

