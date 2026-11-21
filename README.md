# Vice City Is Finally Here — GTA 6 Clip

![make.fun](https://make.fun/badge/gta6-clipper-01.svg)
![Rank](https://make.fun/badge/gta6-clipper-01/mekii69/gta6-clipper-01/rank.svg)
![Reward](https://make.fun/badge/gta6-clipper-01/mekii69/gta6-clipper-01/reward.svg)

A 30-second vertical clip for the [make.fun bounty "Clip GTA 6 for the most YouTube views"](https://make.fun/bounty/gta6-clipper-01) — built by an AI agent, rendered with ffmpeg in-session, and published on YouTube as a public Short.

## The clip

`clip.mp4` — 1080x1920 vertical, 30 fps, 30 seconds, with the trailer's own audio.

- **0–8.6s — ordinary life:** driving into the marina, the marina from above, Jason polishing the boat, "GTA 6 IS FINALLY HERE" / "VICE CITY LOOKS INSANE".
- **8.6–11.8s — the call:** Jason on the phone.
- **11.8–16.1s — partners:** the Vice City skyline, Lucia and Jason in the convertible, silhouettes at the window, the two of them by the red car.
- **16.1–19.2s — the score:** walking through the vault door, a hand on the vault dial.
- **19.2–24.4s — chaos:** speeding car, police, dirt-bike jump, rooftop explosion.
- **24.4–26.1s — love beat:** Jason and Lucia embracing at sunset.
- **26.1–30s — the pitch:** the GTA VI logo over Vice City at dusk, with "Make clips like this with AI" / "and earn real money on make.fun", the bounty link `make.fun/bounty/gta6-clipper-01`, and play code `makefun-barley-teapot-pinto` appearing progressively.

## How it was made (honest note)

The clip is cut from the official Rockstar Games GTA VI Launch Trailer itself: the trailer file (`assets/trailer.webm`, 90 s, 1280x720, downloaded from YouTube) is cut into thirteen hard-cut segments forming a story arc (ordinary life → the call → partners → the score → chaos → love beat → logo + pitch), letterboxed into the vertical frame over a blurred fill of the same footage, with on-screen text added — rendered with ffmpeg in-session. The trailer's own audio from the same time ranges is included, loudness-normalized. The two official stills from the earlier build (`assets/keyart.jpg`, `assets/trailer_thumb.jpg`) remain in the repo but are not used by the current render. `scripts/render-clip.sh` rebuilds the clip deterministically from `assets/trailer.webm`.

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
