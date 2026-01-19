#!/bin/bash

TAG="$1"
sudo snapper -c root create --description "quick-root${TAG:+-$TAG}" --cleanup-algorithm number
sudo snapper -c root cleanup number
sudo snapper -c home create --description "quick-home${TAG:+-$TAG}" --cleanup-algorithm number
sudo snapper -c home cleanup number
notify-send "Quick Snapshot ($TAG, $(date '+%F %T'))"
