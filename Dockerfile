# syntax=docker/dockerfile:1

# 1. Tumia jina la toleo lako (Version)
ARG VERSION_ARG="1.0.0"
FROM scratch AS build-amd64

# Tunachukua QEMU (Injini ya kuendesha Windows)
COPY --from=qemux/qemu:7.29 / /

ARG TARGETARCH
ARG DEBCONF_NOWARNINGS="yes"
ARG DEBIAN_FRONTEND="noninteractive"
ARG DEBCONF_NONINTERACTIVE_SEEN="true"

# Sakinisha vikorokoro vya lazima
RUN set -eu && \
    apt-get update && \
    apt-get --no-install-recommends -y install \
        samba \
        wimtools \
        dos2unix \
        cabextract \
        libxml2-utils \
        libarchive-tools && \
    wget "https://github.com/gershnik/wsdd-native/releases/download/v1.22/wsddn_1.22_${TARGETARCH}.deb" -O /tmp/wsddn.deb -q && \
    dpkg -i /tmp/wsddn.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 2. Hapa ndipo kodi zako za 'Lugha ya Mashine' zinaingia
# Tunachukua folder lako la 'src' na 'assets' (yale uliyobadilisha jina)
COPY --chmod=755 ./src /run/
COPY --chmod=755 ./assets /run/assets

# Madereva ya Windows (Virtio)
ADD --chmod=664 https://github.com/qemus/virtiso-whql/releases/download/v1.9.49-0/virtio-win-1.9.49.tar.xz /var/drivers.txz

# 3. MUHIMU: Badilisha 'dockurr' hapa kama unajenga ARM version
# Kama unajenga kwa ajili ya PC za kawaida (x64), hii sehemu itaruka
FROM newboytz/windows-arm:${VERSION_ARG} AS build-arm64
FROM build-${TARGETARCH}

# Weka alama yako ya utambulisho
ARG VERSION_ARG="1.0.0"
RUN echo "MyDesktopOS v$VERSION_ARG" > /run/version

# Maeneo ya kuhifadhi data
VOLUME /storage
EXPOSE 3389 8006

# 4. Mipangilio ya awali ya MyDesktopOS
ENV VERSION="11"
ENV RAM_SIZE="4G"
ENV CPU_CORES="2"
ENV DISK_SIZE="64G"
ENV NAME="MyDesktopOS"

# 5. Amri ya kuanzisha mfumo (Inatumia script yako uliyo-edit)
ENTRYPOINT ["/usr/bin/tini", "-s", "/run/entry.sh"]

