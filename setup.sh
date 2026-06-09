#!/bin/bash
set -e

echo "=== ComfyUI Setup ==="

cd /workspaces

# Clone ComfyUI
if [ ! -d "ComfyUI" ]; then
  echo "[1/6] Cloning ComfyUI..."
  git clone https://github.com/comfyanonymous/ComfyUI.git
fi

cd ComfyUI

# Install Python dependencies
echo "[2/6] Installing ComfyUI dependencies..."
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu 2>&1 | tail -5
pip install -r requirements.txt 2>&1 | tail -5

# Install ComfyUI Manager
echo "[3/6] Installing ComfyUI Manager..."
cd custom_nodes
if [ ! -d "ComfyUI-Manager" ]; then
  git clone https://github.com/Comfy-Org/ComfyUI-Manager.git
  pip install -r ComfyUI-Manager/requirements.txt 2>&1 | tail -3
fi
cd ..

# Install missing custom nodes needed for built-in workflows
echo "[4/6] Installing custom nodes for built-in workflows..."
cd custom_nodes
# WAS Node Suite (needed for some workflows)
if [ ! -d "was-node-suite-comfyui" ]; then
  git clone https://github.com/WASasquatch/was-node-suite-comfyui.git
  pip install -r was-node-suite-comfyui/requirements.txt 2>&1 | tail -3 || true
fi
cd ..

# Install localtunnel for tunnel
echo "[5/6] Installing localtunnel..."
npm install -g localtunnel 2>&1 | tail -3

echo "[6/6] Setup complete!"
echo ""
echo "To start ComfyUI + tunnel, run:"
echo "  bash /workspaces/comfyui-space/start.sh"
