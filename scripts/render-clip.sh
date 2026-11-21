#!/usr/bin/env bash
# Render clip.mp4 for the make.fun gta6-clipper-01 bounty.
# Cut from assets/trailer.webm — the official Rockstar Games GTA VI Launch
# Trailer file (90 s, 1280x720), downloaded from YouTube. The clip is real
# moving trailer footage, cut in-session: five hard-cut segments in the
# style of the reference Short (16:9 footage letterboxed mid-frame over a
# blurred, darkened fill of the same footage), hook text up front, and the
# make.fun pitch lines appearing progressively over the closing shot.
#
# Output: 1080x1920 vertical, 30 fps, 30 s, H.264, silent.
#   0.0-5.5s   highway into Leonida, jet ski on the trailer (trailer 1.0-6.5s)
#              hook text: GTA 6 IS FINALLY HERE / VICE CITY LOOKS INSANE
#   5.5-10.5s  lowrider crew (trailer 18.5-23.5s)
#   10.5-16s   dirt-bike jump over the palms (trailer 48.0-53.5s)
#   16-23.5s   night action (trailer 58.5-66.0s)
#   23.5-30s   GTA VI logo over Vice City at dusk (trailer 74.0-80.5s)
#              progressive text: pitch lines + bounty link + play code
#
# No trailer audio is used: the output is silent.
#
# Usage: run from the repository root:  bash scripts/render-clip.sh
set -euo pipefail
cd "$(dirname "$0")/.."

FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf
SRC=assets/trailer.webm
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# Shared layout: blurred dark fill behind a centered 1080x607 band.
# $1 = start, $2 = duration, $3 = extra drawtext filters (may be empty),
# $4 = output file.
render_seg() {
  local start="$1" dur="$2" text="$3" out="$4"
  local filters="[0:v]split[a][b];"
  filters+="[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=45,eq=brightness=-0.35:saturation=0.9[bg];"
  filters+="[b]scale=1080:607[fg];"
  filters+="[bg][fg]overlay=(W-w)/2:(H-h)/2"
  if [ -n "$text" ]; then
    filters+=",${text}"
  fi
  filters+=",format=yuv420p"
  ffmpeg -y -v error -ss "$start" -t "$dur" -i "$SRC" \
    -filter_complex "$filters" -r 30 -c:v libx264 -preset medium -crf 20 \
    -an "$WORK/$out"
}

# Segment A: hook.
render_seg 1.0 5.5 \
  "drawtext=fontfile=$FONT:text='GTA 6 IS FINALLY HERE':fontsize=66:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=700,drawtext=fontfile=$FONT:text='VICE CITY LOOKS INSANE':fontsize=60:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=1150" \
  segA.mp4

# Segment B: lowrider crew, no text.
render_seg 18.5 5.0 "" segB.mp4

# Segment C: dirt-bike jump, no text.
render_seg 48.0 5.5 "" segC.mp4

# Segment D: night action, no text.
render_seg 58.5 7.5 "" segD.mp4

# Segment E: logo over dusk city, progressive pitch text.
# Ends at 80.5s to stay clear of the trailer's own pre-order end card.
render_seg 74.0 6.5 \
  "drawtext=fontfile=$FONT:text='Make clips like this with AI':fontsize=56:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=700,drawtext=fontfile=$FONT:text='and earn real money on make.fun':fontsize=50:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=800:enable='between(t,2.0,6.5)',drawtext=fontfile=$FONT:text='make.fun/bounty/gta6-clipper-01':fontsize=44:fontcolor=#ffd166:borderw=2:bordercolor=black:x=(w-text_w)/2:y=930:enable='between(t,3.5,6.5)',drawtext=fontfile=$FONT:text='Play code\\: makefun-barley-teapot-pinto':fontsize=38:fontcolor=white:borderw=2:bordercolor=black:x=(w-text_w)/2:y=1030:enable='between(t,4.5,6.5)'" \
  segE.mp4

# Concatenate the five segments (identical codec parameters, stream copy).
printf "file '%s/segA.mp4'\nfile '%s/segB.mp4'\nfile '%s/segC.mp4'\nfile '%s/segD.mp4'\nfile '%s/segE.mp4'\n" \
  "$WORK" "$WORK" "$WORK" "$WORK" "$WORK" > "$WORK/list.txt"
ffmpeg -y -v error -f concat -safe 0 -i "$WORK/list.txt" -c copy -movflags +faststart clip.mp4

ffprobe -v error -show_entries format=duration,size -show_entries stream=width,height,r_frame_rate,codec_name -of default=noprint_wrappers=1 clip.mp4
