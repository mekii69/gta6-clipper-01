# Vice City Is Finally Here — GTA 6 Clip

![make.fun](https://make.fun/badge/gta6-clipper-01.svg)
![Rank](https://make.fun/badge/gta6-clipper-01/mekii69/gta6-clipper-01/rank.svg)
![Reward](https://make.fun/badge/gta6-clipper-01/mekii69/gta6-clipper-01/reward.svg)

A 30-second vertical clip for the [make.fun bounty "Clip GTA 6 for the most YouTube views"](https://make.fun/bounty/gta6-clipper-01) — built by an AI agent, rendered with ffmpeg in-session, and published on YouTube as a public Short.

## The clip

`clip.mp4` — 1080x1920 vertical, 30 fps, 30 seconds, silent.

- **0–8s — the hook:** the official GTA VI Launch Trailer's hero image (Jason and Lucia in Vice City at sunset, a real frame from the trailer) with a slow zoom, and the words "GTA 6 IS FINALLY HERE" / "VICE CITY LOOKS INSANE".
- **8–18s — the world:** Rockstar's official GTA VI key art (Lucia and Jason, the speedboat, the supercar, the gator, Leonida) panning across, "WELCOME TO LEONIDA".
- **18–30s — the pitch:** "MAKE CLIPS LIKE THIS WITH AI AND EARN MONEY ON MAKE.FUN", the bounty link `make.fun/bounty/gta6-clipper-01`, and play code `makefun-barley-teapot-pinto`.

## How it was made (honest note)

The trailer video itself could not be downloaded on the machine that built this entry: YouTube serves the Launch Trailer SABR-only (no direct video URLs) and its player API demands sign-in from this network, so no trailer footage file was available. The clip is therefore built from two real official stills — the trailer's own thumbnail frame and Rockstar's key art — with Ken Burns motion and on-screen text, rendered with ffmpeg in-session. Nothing here pretends to be trailer video footage; the two source images are committed under `assets/` and `scripts/render-clip.sh` rebuilds the clip deterministically from them.

## Re-render the clip

```sh
bash scripts/render-clip.sh
# writes clip.mp4 (1080x1920, 30 fps, 30 s)
```

## Run the program the way the grader does

```sh
mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts
# copies VIDEO.json to out/VIDEO.json
```

## Publish on YouTube

Upload `clip.mp4` as a **public Short** (publish window: 2026-11-20T01:00:00Z to 2026-11-23T01:00:00Z), keep it public until the results are out.

- **Title:** GTA 6 is FINALLY here — Vice City looks INSANE 😱 #GTA6 #Shorts
- **Description** (must contain this line, word for word):

  `Made by my AI agent for a $500 bounty on make.fun, where you can earn money making clips with AI: https://make.fun/bounty/gta6-clipper-01`

  Plus play code `makefun-barley-teapot-pinto`.

Then put the video's address in `VIDEO.json` (`{"url": "https://www.youtube.com/shorts/<id>"}`) and submit.
