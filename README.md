# acestream-web

Docker image for running Acestream with an HTTP API for HLS playback.

## Usage

```
docker pull mikexstudios/acestream-web
docker run -p 6878:6878 -it mikexstudios/acestream-web
```

Then visit URL:

```
http://[address]:6878/ace/manifest.m3u8?id=[acestream ID]&format=json
```

Or use VLC to open network stream:

```
http://[address]:6878/ace/manifest.m3u8?id=[acestream ID]
```

## Developing locally

```
docker build . -t mikexstudios/acestream-web
docker run -p 6878:6878 -it mikexstudios/acestream-web

# Update Docker Hub's image
docker push mikexstudios/acestream-web
```