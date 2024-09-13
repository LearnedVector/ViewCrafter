# Use an official CUDA-enabled PyTorch image as the base
FROM pytorch/pytorch:1.13.1-cuda11.6-cudnn8-runtime

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*


# Upgrade pip to the latest version
RUN pip install --no-cache-dir --upgrade pip

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Install dependencies separately to handle conflicts
RUN pip install --no-cache-dir --upgrade Jinja2>=3.1.0 MarkupSafe>=2.1.0

# Install PyTorch3D via pip (adjust the URL based on your environment)
RUN pip install --no-cache-dir pytorch3d -f https://dl.fbaipublicfiles.com/pytorch3d/packaging/wheels/py310_cu116_pyt1131/download.html

# Download DUSt3R checkpoint
RUN mkdir -p checkpoints/ && \
    wget https://download.europe.naverlabs.com/ComputerVision/DUSt3R/DUSt3R_ViTLarge_BaseDecoder_512_dpt.pth -P checkpoints/

# Set environment variables
ENV PYTHONPATH=/app

COPY . .

# Run gradio app
CMD ["python", "gradio_app.py"]