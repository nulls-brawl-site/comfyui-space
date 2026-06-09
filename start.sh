#!/bin/bash

echo "=== Starting ComfyUI ==="

# Start ComfyUI in background (CPU mode)
cd /workspaces/ComfyUI
python main.py --listen 0.0.0.0 --port 8188 --cpu &
COMFY_PID=$!
echo "ComfyUI started (PID: $COMFY_PID)"

# Wait for ComfyUI to be ready
echo "Waiting for ComfyUI to start..."
for i in $(seq 1 60); do
  if curl -s http://localhost:8188/ > /dev/null 2>&1; then
    echo "ComfyUI is ready!"
    break
  fi
  sleep 2
done

# Start localtunnel
echo ""
echo "=== Starting localtunnel ==="
lt --port 8188 --subdomain comfyspace-$(cat /proc/sys/kernel/random/uuid | tr -d '-' | head -c 8) 2>&1 &
LT_PID=$!

sleep 3
echo ""
echo "========================================="
echo "ComfyUI is running!"
echo "Check tunnel URL above (lt output)"
echo "Use that URL in .cfg ComfyImageGen comfyui_url"
echo "========================================="

wait $COMFY_PID
