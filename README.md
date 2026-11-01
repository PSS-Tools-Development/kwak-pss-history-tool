# [The Worst Ever PSS History Tool](https://pss-tools-development.github.io/kwak-pss-history-tool/)

A single-page web-app with all data integrated to be hosted on Github Pages.

## ❓ What this is

The tool is **one self-contained static HTML page** (`index.html`, ~33 MB): the 2019-2026
tournament archive, the font and all the code are embedded in it. In the browser it calls
[fleetdata.dolores2.xyz](https://fleetdata.dolores2.xyz) directly for the current month and
`api.pixelstarships.com` for player search.

```
index.html     the built tool (replaced on every release)
```

## 🏃‍➡️ Run it

Open [index.html](.\index.html) in a browser with Javascript enabled.

## ⚙️ Automatic updates from GitHub

This repository has been set up to be published to Github Pages: https://pss-tools-development.github.io/kwak-pss-history-tool/

## 🛠️ Release flow (Strategery's side)

`build_html.py` in the main project writes the new page straight to `webapp/index.html`.
Commit and push:

```bash
git add index.html
git commit -m "Build 2026-10-28"
git push
```

Note: at ~33 MB per build the git history grows by that much per release. It is well under
GitHub's 100 MB per-file limit; if the repo ever gets unwieldy, track `index.html` with
[Git LFS](https://git-lfs.com) (`git lfs track "index.html"`) - the workflow checks out LFS
files automatically if you add `lfs: true` to the `actions/checkout` step.

## 🔗 Links

- **WebApp** – [pss-tools-development.github.io/](https://pss-tools-development.github.io/kwak-pss-history-tool/)
- **Repository** – [Github.com](https://github.com/PSS-Tools-Development/kwak-pss-history-tool/)
- **Support Discord** – [Support Discord](https://support.dolores2.xyz)
- **Donate** – [kofi (The worst.)](https://ko-fi.com/theworstpss) [buymeacoffee (The worst.)](https://buymeacoffee.com/the_worst_pss)
