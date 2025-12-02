#!/bin/bash
GPU_UTIL=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
echo "{\"percentage\": $GPU_UTIL,\"tooltip\": \"GPU Utilization: $GPU_UTIL%\nGPU Temperature: $GPU_TEMP°C\"}"

	
