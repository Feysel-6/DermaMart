"""
Standalone Flask API server for makeup recommendation
This version doesn't require Bazel and can be run directly with Python

Usage:
    pip install -r requirements.txt
    python standalone_server.py --host 0.0.0.0 --port 8080
"""

import sys
import os
import logging
from pathlib import Path

# Add project directories to Python path
project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))
sys.path.insert(0, str(project_root / "automakeup"))
sys.path.insert(0, str(project_root / "ganette"))
sys.path.insert(0, str(project_root / "imagine"))
sys.path.insert(0, str(project_root / "modelutils"))
sys.path.insert(0, str(project_root / "third_party" / "mtcnn"))
sys.path.insert(0, str(project_root / "third_party" / "faceparsing"))
sys.path.insert(0, str(project_root / "third_party" / "facenet"))

import argparse
import torch
import cv2
import numpy as np
import json
from flask import Flask, request, jsonify
from flask_cors import CORS

# Import project modules
from automakeup.pipelines import GanettePipeline
from imagine.color.conversion import BgrToRgb

app = Flask(__name__)
CORS(app)  # Enable CORS for Flutter app

# Global pipeline instance and device
pipeline = None
device = None
logger = logging.getLogger(__name__)


def get_device():
    """Get PyTorch device (CUDA if available, else CPU)"""
    return torch.device('cuda' if torch.cuda.is_available() else 'cpu')


def init_pipeline(dev):
    """Initialize the makeup recommendation pipeline"""
    global pipeline, device
    device = dev
    logger.info(f"Initializing pipeline on device: {device}")
    try:
        pipeline = GanettePipeline(device=device)
        logger.info("Pipeline initialized successfully")
        return True
    except Exception as e:
        logger.error(f"Failed to initialize pipeline: {e}", exc_info=True)
        return False


@app.route('/', methods=['POST'])
def recommend_makeup():
    """
    Main endpoint for makeup recommendation
    
    Request:
        - POST with multipart/form-data
        - Field name: 'img' (image file)
    
    Response:
        JSON with recommended makeup colors:
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
    """
    if pipeline is None:
        return jsonify({"error": "Pipeline not initialized"}), 500
    
    if 'img' not in request.files:
        return jsonify({"error": "No image file provided. Use 'img' field."}), 400
    
    try:
        # Read image from request
        file = request.files['img']
        image_bytes = file.read()
        
        # Convert to numpy array and decode
        array = np.frombuffer(image_bytes, dtype=np.uint8)
        img_bgr = cv2.imdecode(array, cv2.IMREAD_COLOR)
        
        if img_bgr is None:
            return jsonify({"error": "Invalid image format"}), 400
        
        # Convert BGR to RGB
        img_rgb = BgrToRgb(img_bgr)
        
        # Run pipeline
        result = pipeline.run(img_rgb)
        
        # Convert result to dictionary
        result_dict = {
            "skin_color": result.skin_color,
            "hair_color": result.hair_color,
            "lips_color": result.lips_color,
            "eyes_color": result.eyes_color,
            "lipstick_color": result.lipstick_color,
            "eyeshadow_outer_color": result.eyeshadow_outer_color,
            "eyeshadow_middle_color": result.eyeshadow_middle_color,
            "eyeshadow_inner_color": result.eyeshadow_inner_color
        }
        
        return jsonify(result_dict)
        
    except Exception as e:
        logger.error(f"Error processing request: {e}", exc_info=True)
        return jsonify({"error": f"Processing error: {str(e)}"}), 500


@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        "status": "healthy",
        "pipeline_loaded": pipeline is not None,
        "device": str(device) if device else None
    })


def main():
    parser = argparse.ArgumentParser(description="Makeup Recommendation API Server")
    parser.add_argument('--host', type=str, default='0.0.0.0', help='Host to bind to')
    parser.add_argument('--port', type=int, default=8080, help='Port to listen on')
    parser.add_argument('--device', type=str, default='auto', 
                       choices=['auto', 'cpu', 'cuda'],
                       help='Device to use (auto=detect, cpu=CPU only, cuda=GPU if available)')
    args = parser.parse_args()
    
    # Configure logging
    logging.basicConfig(
        level=logging.INFO,
        format='[%(asctime)s] [%(levelname)s] [%(name)s] %(message)s'
    )
    
    # Determine device
    if args.device == 'auto':
        device = get_device()
    elif args.device == 'cuda':
        device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        if not torch.cuda.is_available():
            logger.warning("CUDA requested but not available, using CPU")
    else:
        device = torch.device('cpu')
    
    logger.info(f"Using device: {device}")
    
    # Initialize pipeline
    if not init_pipeline(device):
        logger.error("Failed to initialize pipeline. Exiting.")
        sys.exit(1)
    
    # Start server
    logger.info(f"Starting server on {args.host}:{args.port}")
    logger.info("API endpoint: POST /")
    logger.info("Health check: GET /health")
    app.run(host=args.host, port=args.port, debug=False)


if __name__ == '__main__':
    main()

