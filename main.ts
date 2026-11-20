// gta6-clipper-01 entry (Node 22, standard library only).
//
// The entry is the video itself: a vertical GTA 6 clip, rendered in-session
// with ffmpeg (see scripts/render-clip.sh), uploaded to YouTube as a public
// Short with the bounty's line and a play code in its description. This
// program only hands the video's address to the gate: it copies VIDEO.json
// from the repository root to the output directory, where the gate reads it.
// That is all it does. Nothing this program writes about the video is scored.
//
// VIDEO.json ships with a placeholder address, so the gate refuses it as it
// stands. Replace it with the real YouTube Shorts address before submitting.
//
// Run the way the grader does:
//   mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts

import { copyFileSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';

const BOT_DIR = process.env.MAKEFUN_BOT_DIR ?? '/bot';
const OUTPUT_DIR = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';

mkdirSync(OUTPUT_DIR, { recursive: true });

try {
  copyFileSync(join(BOT_DIR, 'VIDEO.json'), join(OUTPUT_DIR, 'VIDEO.json'));
} catch (err) {
  console.error(`VIDEO.json could not be copied from ${BOT_DIR}: ${(err as Error).message}`);
  process.exit(1);
}
