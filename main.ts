// Entry point for the GTA 6 clipper submission.
//
// The finished video already exists in this repository as VIDEO.json.
// This program does one small job: put that exact file into the
// output directory the harness collects from, and nothing else.
// No rendering, no editing, and no network calls happen here.

import { copyFile, mkdir } from "node:fs/promises";
import path from "node:path";

async function placeFinishedVideo() {
  const repositoryRoot = process.env.MAKEFUN_BOT_DIR ?? ".";
  const outputDirectory = process.env.MAKEFUN_OUTPUT_DIR ?? "/output";

  const videoSource = path.resolve(repositoryRoot, "VIDEO.json");
  const videoDestination = path.join(outputDirectory, "VIDEO.json");

  await mkdir(outputDirectory, { recursive: true });
  await copyFile(videoSource, videoDestination);
}

try {
  await placeFinishedVideo();
} catch (failure) {
  console.error("Could not copy VIDEO.json to the output directory:", failure);
  process.exit(1);
}
