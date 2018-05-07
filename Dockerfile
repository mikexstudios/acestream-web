FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
  python2.7 libpython2.7 python-setuptools python-m2crypto python-apsw \
  python-lxml \
  && rm -rf /var/lib/apt/lists/*
# Create a dummy disk directory to suppress startup error message.
RUN mkdir -p /dev/disk/by-id

WORKDIR /root/
COPY acestream_3.1.16_ubuntu_16.04_x86_64.tar.gz ./
RUN tar zxf acestream_3.1.16_ubuntu_16.04_x86_64.tar.gz && \
  rm acestream_3.1.16_ubuntu_16.04_x86_64.tar.gz && \
  mv acestream_3.1.16_ubuntu_16.04_x86_64 acestream

# Start the acestream-engine in console mode, exposing HTTP API port.
EXPOSE 6878
CMD acestream/start-engine --client-console