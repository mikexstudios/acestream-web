FROM ubuntu:16.04

# Install python dependencies for acestream.
# See: http://wiki.acestream.org/wiki/index.php/Install_Ubuntu
RUN apt-get update && apt-get install -y \
  python2.7 libpython2.7 python-setuptools python-m2crypto python-apsw \
  python-lxml \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root/
# Download acestream from: http://wiki.acestream.org/wiki/index.php/Download#Linux
# (Need version >= 3.1 to use HTTP API.)
ENV ACESTREAM_VERSION acestream_3.1.16_ubuntu_16.04_x86_64
# Use `sha256sum` or `openssl sha -sha256` to generate or verify locally.
ENV ACESTREAM_SHA256 452bccb8ae8b5ff4497bbb796081dcf3fec2b699ba9ce704107556a3d6ad2ad7

# For easier development, bypass downloading acestream if a local copy exists.
# Because COPY requires a file to exist, we copy README.md and wildcard match
# any acestream archives.
COPY README.md ${ACESTREAM_VERSION}.* ./
RUN [ -e "${ACESTREAM_VERSION}.tar.gz" ] && \
  mv "${ACESTREAM_VERSION}.tar.gz" "acestream.tar.gz" || true
RUN [ ! -e "./acestream.tar.gz" ] && \
  ( apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/* && \
  wget -O "acestream.tar.gz" "http://dl.acestream.org/linux/${ACESTREAM_VERSION}.tar.gz" && \
  apt-get purge -y --auto-remove wget ) || \
  echo "Skipping download. Using local acestream: ${ACESTREAM_VERSION}.tar.gz."

RUN echo "${ACESTREAM_SHA256} acestream.tar.gz" | sha256sum -c - && \
  tar zxf "acestream.tar.gz" && rm "acestream.tar.gz" && \
  mv ${ACESTREAM_VERSION} acestream

# Install acestream configuration.
COPY .ACEStream ./.ACEStream

# Start the acestream-engine in console mode, exposing HTTP API port.
EXPOSE 6878
CMD acestream/start-engine --client-console --service-remote-access