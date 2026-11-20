#!/usr/bin/env bash
# Render clip.mp4 for the make.fun gta6-clipper-01 bounty.
# Deterministic from repo assets: assets/trailer_thumb.jpg (official GTA VI
# Launch Trailer thumbnail, a real trailer frame) and assets/keyart.jpg
# (Rockstar's official GTA VI key art). No trailer video file is used: the
# trailer itself cannot be downloaded from this machine (YouTube serves it
# SABR-only and its player API demands sign-in), so the clip is built from
# these two real official stills with Ken Burns motion plus on-screen text.
#
# Output: 1080x1920 vertical, 30 fps, 30 s, H.264, silent.
#   0-8s   trailer thumbnail, slow zoom in, hook text
#   8-18s  key-art collage, slow pan across, title text
#   18-30s Vice City gradient pitch card: make.fun pitch + bounty link + play code
#
# Usage: run from the repository root:  bash scripts/render-clip.sh
set -euo pipefail
cd "$(dirname "$0")/.."

FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# Segment A: trailer thumbnail, 8 s, slow zoom in, hook text.
ffmpeg -y -v error -framerate 30 -loop 1 -t 8 -i assets/trailer_thumb.jpg -filter_complex "
[0:v]split[a][b];
[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=45,eq=brightness=-0.35:saturation=0.9[bg];
[b]scale=1080:607,zoompan=z='1+0.0004*on':d=1:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=1080x607:fps=30[fg];
[bg][fg]overlay=(W-w)/2:(H-h)/2,
drawtext=fontfile=$FONT:text='GTA 6 IS FINALLY HERE':fontsize=78:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=300,
drawtext=fontfile=$FONT:text='VICE CITY LOOKS INSANE':fontsize=72:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=1420,
format=yuv420p" -r 30 -c:v libx264 -preset medium -crf 20 -an "$WORK/segA.mp4"

# Segment B: key-art collage, 10 s, slow pan left-to-right, title text.
ffmpeg -y -v error -framerate 30 -loop 1 -t 10 -i assets/keyart.jpg -filter_complex "
[0:v]split[a][b];
[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=45,eq=brightness=-0.35:saturation=0.9[bg];
[b]scale=1080:567,zoompan=z='1.15':d=1:x='(iw-iw/zoom)*on/299':y='ih/2-(ih/zoom/2)':s=1080x567:fps=30[fg];
[bg][fg]overlay=(W-w)/2:(H-h)/2,
drawtext=fontfile=$FONT:text='WELCOME TO LEONIDA':fontsize=76:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=330,
format=yuv420p" -r 30 -c:v libx264 -preset medium -crf 20 -an "$WORK/segB.mp4"

# Segment C: Vice City gradient pitch card, 12 s.
ffmpeg -y -v error -f lavfi -t 12 -i "gradients=s=1080x1920:c0=1a0b2e:c1=ff2e88:x0=540:y0=0:x1=540:y1=1920" -filter_complex "
[0:v]drawtext=fontfile=$FONT:text='MAKE CLIPS LIKE':fontsize=72:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=500,
drawtext=fontfile=$FONT:text='THIS WITH AI':fontsize=72:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=600,
drawtext=fontfile=$FONT:text='AND EARN MONEY ON MAKE.FUN':fontsize=56:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=760,
drawtext=fontfile=$FONT:text='make.fun/bounty/gta6-clipper-01':fontsize=46:fontcolor=#ffd166:borderw=2:bordercolor=black:x=(w-text_w)/2:y=950,
drawtext=fontfile=$FONT:text='Play code\: makefun-barley-teapot-pinto':fontsize=40:fontcolor=white:borderw=2:bordercolor=black:x=(w-text_w)/2:y=1050,
format=yuv420p" -r 30 -c:v libx264 -preset medium -crf 20 -an "$WORK/segC.mp4"

# Concatenate the three segments (identical codec parameters, stream copy).
printf "file '%s/segA.mp4'\nfile '%s/segB.mp4'\nfile '%s/segC.mp4'\n" "$WORK" "$WORK" "$WORK" > "$WORK/list.txt"
ffmpeg -y -v error -f concat -safe 0 -i "$WORK/list.txt" -c copy -movflags +faststart clip.mp4

ffprobe -v error -show_entries format=duration,size -show_entries stream=width,height,r_frame_rate,codec_name -of default=noprint_wrappers=1 clip.mp4
