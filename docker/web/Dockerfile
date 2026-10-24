# check=skip=FromPlatformFlagConstDisallowed
# (the build stage is amd64 on purpose, see below)
#
# The Yumdoor web app (PWA), served by unprivileged nginx under a base path
# that is set at runtime. Build from the repository root:
#
#   docker build -f docker/web/Dockerfile -t yumdoor .
#   docker run --rm -p 8081:8080 -e BASE_PATH=/app/ yumdoor
#
# It must be served from the same origin as Tandoor; README.md#deployment-pwa
# has a reverse-proxy example. The container runs as uid 101 and only writes
# to /tmp, so it also runs with --read-only and a tmpfs on /tmp.

# The output is platform independent and the Flutter SDK is published for x64
# only, so this stage always runs on amd64, also for the arm64 image.
FROM --platform=linux/amd64 debian:trixie-slim@sha256:62bd423aeee912639ca8ee681c2b762cb3e25137e0a92b20be455898a9f034ad AS build

# Must equal environment.flutter in pubspec.yaml (test/tool/docker_web_test.dart).
# The checksum is the release's sha256 in
# https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json
ARG FLUTTER_VERSION=3.47.7
ARG FLUTTER_SHA256=af7455f540df951184c7953fbe3cf884766e7541dacf8571f9f582db03dd6230

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl git unzip xz-utils \
    && rm -rf /var/lib/apt/lists/*
RUN useradd --create-home build
USER build
WORKDIR /home/build

RUN curl -fsSLo flutter.tar.xz "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    && echo "${FLUTTER_SHA256}  flutter.tar.xz" | sha256sum -c - \
    && tar -xJf flutter.tar.xz \
    && rm flutter.tar.xz
ENV PATH="/home/build/flutter/bin:${PATH}"
RUN flutter --disable-analytics && flutter precache --web

WORKDIR /home/build/app
# Dependencies first, so source changes don't invalidate this layer.
COPY --chown=build pubspec.yaml pubspec.lock ./
COPY --chown=build packages/tandoor_api/pubspec.yaml packages/tandoor_api/
RUN flutter pub get --enforce-lockfile
COPY --chown=build . .
# Same flags as the web build in .github/workflows/ci.yml. index.html goes
# apart: the entrypoint writes it with the real base path at start.
RUN flutter build web --release --no-web-resources-cdn --base-href /__BASE_PATH__/ \
    && dart run tool/finish_web_build.dart \
    && mkdir out \
    && mv build/web/index.html out/index.html \
    && mv build/web out/html

FROM nginxinc/nginx-unprivileged:1.30.6-alpine-slim@sha256:5d8bb9437d74a600ec5dbf90c035451c724dc33eac8d3a71078f6f8612c345f6

# Where the app is served; must start and end with "/". Behind the proxy it is
# the same path as in the browser, e.g. https://recipes.example.com/app/.
ENV BASE_PATH=/app/
# Only our variables are substituted into the nginx template, not nginx's own,
# and it is rendered to /tmp, the only place the container writes to.
ENV NGINX_ENVSUBST_FILTER=^BASE_PATH \
    NGINX_ENVSUBST_OUTPUT_DIR=/tmp/yumdoor/nginx

COPY --from=build /home/build/app/out/html/ /usr/share/nginx/html/
COPY --from=build /home/build/app/out/index.html /usr/share/yumdoor/index.html
COPY docker/web/security-headers.conf /etc/nginx/yumdoor/security-headers.conf
COPY docker/web/default.conf /etc/nginx/conf.d/default.conf
COPY docker/web/yumdoor.conf.template /etc/nginx/templates/yumdoor.conf.template
COPY --chmod=755 docker/web/05-yumdoor-base-path.envsh /docker-entrypoint.d/

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
    CMD wget -q -O /dev/null "http://127.0.0.1:8080${BASE_PATH}version.json" || exit 1
