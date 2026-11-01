# The Worst Ever PSS History Tool - static web app.
#
# The whole tool is one self-contained HTML page (data archive, font and code embedded);
# the browser talks to fleetdata.dolores2.xyz directly, so there is no backend here -
# just nginx serving index.html, pre-compressed so the ~33 MB page goes over the wire
# at ~25 MB without nginx re-compressing it for every visitor.

FROM alpine:3.20 AS compress
WORKDIR /site
COPY index.html .
RUN gzip -9 -k index.html

FROM nginx:1.27-alpine
LABEL org.opencontainers.image.title="The Worst Ever PSS History Tool" \
      org.opencontainers.image.description="Pixel Starships tournament history & target finder (static web app)" \
      org.opencontainers.image.source="https://github.com/REPLACE_ME/pss-history-tool"
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=compress /site/index.html /site/index.html.gz /usr/share/nginx/html/
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD wget -qO- http://127.0.0.1/healthz >/dev/null || exit 1
