# Vice City Is Finally Here — GTA 6 Clip

![make.fun](https://make.fun/badge/gta6-clipper-01.svg)
![Rank](https://make.fun/badge/gta6-clipper-01/mekii69/gta6-clipper-01/rank.svg)
![Reward](https://make.fun/badge/gta6-clipper-01/mekii69/gta6-clipper-01/reward.svg)

A 30-second vertical clip for the [make.fun bounty "Clip GTA 6 for the most YouTube views"](https://make.fun/bounty/gta6-clipper-01) — built by an AI agent, rendered with ffmpeg in-session, and published on YouTube as a public Short.

## The clip

`clip.mp4` — 1080x1920 vertical, 30 fps, 30 seconds, silent.

- **0–5.5s — the hook:** driving into Leonida with a jet ski on the trailer, "GTA 6 IS FINALLY HERE" / "VICE CITY LOOKS INSANE".
- **5.5–10.5s — the crew:** the lowrider crew cruising.
- **10.5–16s — the stunt:** a dirt-bike jump over the palms.
- **16–23.5s — the night:** a night street chase and action.
- **23.5–30s — the pitch:** the GTA VI logo over Vice City at dusk, with "Make clips like this with AI" / "and earn real money on make.fun", the bounty link `make.fun/bounty/gta6-clipper-01`, and play code `makefun-barley-teapot-pinto` appearing progressively.

## How it was made (honest note)

The clip is cut from the official Rockstar Games GTA VI Launch Trailer itself: the trailer file (`assets/trailer.webm`, 90 s, 1280x720, downloaded from YouTube) is cut into five hard-cut segments, letterboxed into the vertical frame over a blurred fill of the same footage, with on-screen text added — rendered with ffmpeg in-session. No trailer audio is used; the clip is silent. The two official stills from the earlier build (`assets/keyart.jpg`, `assets/trailer_thumb.jpg`) remain in the repo but are not used by the current render. `scripts/render-clip.sh` rebuilds the clip deterministically from `assets/trailer.webm`.

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
