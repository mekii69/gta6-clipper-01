#!/usr/bin/env bash
# Render clip.mp4 for the make.fun gta6-clipper-01 bounty.
# Cut from assets/trailer.webm — the official Rockstar Games GTA VI Launch
# Trailer file (90 s, 1280x720), downloaded from YouTube. The clip is real
# moving trailer footage, cut in-session as a STORY arc in the style of the
# reference Short (16:9 footage letterboxed mid-frame over a blurred,
# darkened fill of the same footage), with the trailer's own audio from the
# same time ranges as each picture segment, hook text up front, and the
# make.fun pitch lines appearing progressively over the closing shot.
#
# Story arc (trailer timestamps; total exactly 30.0 s):
#   Beat 1 — ordinary life: highway into the marina (2.0-4.2),
#     marina aerial (4.2-6.5), Jason polishing the boat / boat work (6.5-10.9).
#     Hook text: GTA 6 IS FINALLY HERE / VICE CITY LOOKS INSANE.
#   Beat 2 — the call: Jason on the phone (11.0-14.3).
#   Beat 3 — partners: skyline + Lucia and Jason in the convertible
#     (25.0-26.9), silhouettes at the window (36.0-37.0),
#     Jason and Lucia by the red car (40.2-41.6).
#   Beat 4 — the score: walking through the vault door (34.2-35.8),
#     hand on the vault dial (42.8-44.0).
#   Beat 5 — chaos: speeding car, police, dirt-bike jump (46.2-50.2),
#     rooftop explosion (52.3-53.4).
#   Beat 6 — love beat: Jason and Lucia embracing at sunset (66.2-67.9).
#   Beat 7 — logo + pitch: GTA VI logo over Vice City at dusk (76.0-79.9),
#     progressive pitch text. Ends before the trailer's pre-order end card.
#
# Output: 1080x1920 vertical, 30 fps, 30.0 s, H.264 + AAC stereo audio
# (trailer audio, loudness-normalized).
#
# Usage: run from the repository root:  bash scripts/render-clip.sh
set -euo pipefail
cd "$(dirname "$0")/.."

FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf
SRC=assets/trailer.webm
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

HOOK="drawtext=fontfile=$FONT:text='GTA 6 IS FINALLY HERE':fontsize=66:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=700,drawtext=fontfile=$FONT:text='VICE CITY LOOKS INSANE':fontsize=60:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=1150"
PITCH="drawtext=fontfile=$FONT:text='Make clips like this with AI':fontsize=56:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=420,drawtext=fontfile=$FONT:text='and earn real money on make.fun':fontsize=50:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=510:enable='between(t,1.2,3.9)',drawtext=fontfile=$FONT:text='make.fun/bounty/gta6-clipper-01':fontsize=44:fontcolor=#ffd166:borderw=2:bordercolor=black:x=(w-text_w)/2:y=1400:enable='between(t,2.2,3.9)',drawtext=fontfile=$FONT:text='Play code\\: makefun-barley-teapot-pinto':fontsize=38:fontcolor=white:borderw=2:bordercolor=black:x=(w-text_w)/2:y=1490:enable='between(t,3.0,3.9)'"

# Shared layout: blurred dark fill behind a centered 1080x607 band, plus
# the segment's own trailer audio resampled to 48 kHz stereo.
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
  filters+=",format=yuv420p[v];[0:a]aresample=48000[a]"
  ffmpeg -y -v error -ss "$start" -t "$dur" -i "$SRC" \
    -filter_complex "$filters" -map "[v]" -map "[a]" \
    -r 30 -c:v libx264 -preset medium -crf 20 -c:a aac -b:a 192k \
    "$WORK/$out"
}

render_seg 2.0 2.2 "$HOOK" seg01.mp4
render_seg 4.2 2.3 "$HOOK" seg02.mp4
render_seg 6.5 4.4 "$HOOK" seg03.mp4
render_seg 11.0 3.3 "" seg04.mp4
render_seg 25.0 1.9 "" seg05.mp4
render_seg 36.0 1.0 "" seg06.mp4
render_seg 40.2 1.4 "" seg07.mp4
render_seg 34.2 1.6 "" seg08.mp4
render_seg 42.8 1.2 "" seg09.mp4
render_seg 46.2 4.0 "" seg10.mp4
render_seg 52.3 1.1 "" seg11.mp4
render_seg 66.2 1.7 "" seg12.mp4
render_seg 76.0 3.9 "$PITCH" seg13.mp4

# Concatenate the thirteen segments (identical codec parameters, stream copy).
{
  for i in 01 02 03 04 05 06 07 08 09 10 11 12 13; do
    printf "file '%s/seg%s.mp4'\n" "$WORK" "$i"
  done
} > "$WORK/list.txt"
ffmpeg -y -v error -f concat -safe 0 -i "$WORK/list.txt" -c copy "$WORK/concat.mp4"

# Loudness-normalize the trailer audio across the whole clip; video copied.
# -t 30 pins the output to exactly 30.0 s.
ffmpeg -y -v error -i "$WORK/concat.mp4" -t 30 \
  -c:v copy -af loudnorm=I=-14:TP=-1.5:LRA=11,aresample=48000 -c:a aac -b:a 192k \
  -movflags +faststart clip.mp4

ffprobe -v error -show_entries format=duration,size -show_entries stream=codec_type,codec_name,width,height,r_frame_rate,channels,sample_rate -of default=noprint_wrappers=1 clip.mp4
