#!/usr/bin/env bash
set -euo pipefail

# Transcode a video into HLS adaptive bitrate segments
# and place the output in the project's hls/ directory.
#
# Usage: scripts/transcode-hls.sh <input-video>
#
# Quality tiers:
#   1080p @ 5000k (skipped if source is 720p or lower)
#   720p  @ 2800k
#   480p  @ 1400k

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HLS_DIR="$PROJECT_DIR/hls"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <input-video>" >&2
    exit 1
fi

INPUT="$1"

if [ ! -f "$INPUT" ]; then
    echo "Error: file not found: $INPUT" >&2
    exit 1
fi

if ! command -v ffprobe &>/dev/null || ! command -v ffmpeg &>/dev/null; then
    echo "Error: ffmpeg/ffprobe not found. Install with: brew install ffmpeg" >&2
    exit 1
fi

# Detect source resolution
HEIGHT=$(ffprobe -v error -select_streams v:0 \
    -show_entries stream=height -of csv=p=0 "$INPUT")

echo "Source height: ${HEIGHT}p"

# Clean previous output
rm -rf "$HLS_DIR"

if [ "$HEIGHT" -gt 720 ]; then
    echo "Transcoding 3 tiers: 1080p, 720p, 480p"
    mkdir -p "$HLS_DIR/0" "$HLS_DIR/1" "$HLS_DIR/2"

    ffmpeg -i "$INPUT" \
        -map 0:v -map 0:a -map 0:v -map 0:a -map 0:v -map 0:a \
        -s:v:0 1920x1080 -b:v:0 5000k \
        -s:v:1 1280x720  -b:v:1 2800k \
        -s:v:2 854x480   -b:v:2 1400k \
        -var_stream_map "v:0,a:0 v:1,a:1 v:2,a:2" \
        -master_pl_name conway.m3u8 \
        -f hls -hls_time 6 -hls_list_size 0 \
        -hls_segment_filename "$HLS_DIR/%v/seg_%03d.ts" \
        "$HLS_DIR/%v/stream.m3u8"
else
    echo "Source is ${HEIGHT}p — skipping 1080p tier"
    echo "Transcoding 2 tiers: 720p, 480p"
    mkdir -p "$HLS_DIR/0" "$HLS_DIR/1"

    ffmpeg -i "$INPUT" \
        -map 0:v -map 0:a -map 0:v -map 0:a \
        -s:v:0 1280x720  -b:v:0 2800k \
        -s:v:1 854x480   -b:v:1 1400k \
        -var_stream_map "v:0,a:0 v:1,a:1" \
        -master_pl_name conway.m3u8 \
        -f hls -hls_time 6 -hls_list_size 0 \
        -hls_segment_filename "$HLS_DIR/%v/seg_%03d.ts" \
        "$HLS_DIR/%v/stream.m3u8"
fi

echo ""
echo "HLS output written to: $HLS_DIR"
echo "Master playlist: $HLS_DIR/conway.m3u8"
du -sh "$HLS_DIR"
