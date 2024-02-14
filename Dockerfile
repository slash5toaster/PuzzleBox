# build the puzzlebox binary
FROM debian:unstable-slim as PuzzleBuilder

# Otherwize you will get an interactive setup session for gridengine
ENV DEBIAN_FRONTEND=noninteractive
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update \
 && apt-get install -y \
            build-essential \
            gcc \
            libpopt-dev \
 && apt-get clean \
 && pwck -s \
 && grpck -s \
 && rm -rf \
    /tmp/* \
    /var/tmp/*

WORKDIR /tmp/PuzzleBox

COPY . /tmp/PuzzleBox/

RUN cd /tmp/PuzzleBox \
 && make puzzlebox \
 && mv -v puzzlebox entrypoint.sh /usr/local/bin/

WORKDIR /opt//

FROM debian:unstable-slim

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update \
 && apt-get install -y \
            libpopt-dev \
            openscad \
 && apt-get clean \
 && pwck -s

# COPY --from=OpenSCAD /usr/local/bin/ /usr/local/bin/
# COPY --from=OpenSCAD /usr/local/share/ /usr/local/share/
# COPY --from=OpenSCAD /usr/local/share/ /usr/local/share/

COPY --from=PuzzleBuilder /usr/local/bin/ /usr/local/bin/

USER games

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Mandatory Labels
LABEL MAINTAINER="slash5toaster@gmail.com"
LABEL NAME=puzzlebox
LABEL PROJECT=slash5toaster
LABEL VERSION=1.1.0

#### End of File, if this is missing the file has been truncated