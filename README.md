# The Worst Ever PSS History Tool - web app

Everything TheWorst needs to host the tool as a container, with automatic updates when
Strategery pushes a new build to the GitHub repository.

## What this is

The tool is **one self-contained static HTML page** (`index.html`, ~33 MB): the 2019-2026
tournament archive, the font and all the code are embedded in it. In the browser it calls
`fleetdata.dolores2.xyz` directly for the current month (CORS, thanks!) and
`api.pixelstarships.com` for player search. So the container is nothing more than **nginx
serving one file** - no backend, no database, no secrets, no volumes, nothing to back up.

```
webapp/
  index.html                       the built tool (replaced on every release)
  Dockerfile                       alpine gzip step + nginx:alpine
  nginx.conf                       serves the pre-compressed page, /healthz, no-cache ETag
  docker-compose.yml               port 8080 -> 80, restart unless-stopped
  .github/workflows/docker-publish.yml   builds + publishes ghcr.io image on every push
```

## Run it

```bash
docker compose up -d --build
```

Then open <http://localhost:8080>. Health check: `GET /healthz` returns `ok`.

Or without compose:

```bash
docker build -t pss-history-tool .
docker run -d --name pss-history-tool --restart unless-stopped -p 8080:80 pss-history-tool
```

Put it behind your usual reverse proxy / TLS for a public hostname; the page needs nothing
special (no websockets, no server-side routes - `/` is the only path, everything else
redirects to `/`).

## Automatic updates from GitHub

Make this folder the root of a GitHub repository (branch `main`). The included workflow
then builds the image on every push and publishes it as
`ghcr.io/<owner>/<repo>:latest` using the repo's own `GITHUB_TOKEN` - no secrets to add.
After the first run, set the package to **public** once (repo -> Packages -> package
settings) so the host can pull without logging in.

On the host, pick whichever you already use:

* **Watchtower** - the compose file carries the
  `com.centurylinklabs.watchtower.enable=true` label; switch the service from `build: .`
  to `image: ghcr.io/<owner>/<repo>:latest` and Watchtower pulls each new build.
* **Webhook / CI runner** - on push, run `docker compose pull && docker compose up -d`
  (or `docker compose up -d --build` if you'd rather build from the checkout).
* **Plain cron** - `docker compose pull && docker compose up -d` every few minutes is
  fine; the image is only ~26 MB.

Each release is a new `index.html` (and nothing else), so a deploy is one layer and takes
seconds. Browsers get `Cache-Control: no-cache` with an ETag, so a reload shows the new
version immediately.

## Release flow (Strategery's side)

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

## Why it's safe to host

* Static only: nginx serves one file and a `/healthz` text; no code runs on the server.
* No inbound data: the page never posts anything to the host. The PVP Loss Recorder stores
  its records in the visitor's own browser (localStorage) and exports a CSV they send to
  Strategery by hand.
* Outbound from the **visitor's browser** only: `fleetdata.dolores2.xyz` and
  `api.pixelstarships.com`, plus the Ko-fi link.
* The image runs nginx's stock non-root worker processes; nothing is mounted from the host.
