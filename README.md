# aws-emulator-docker

Docker image for [AWS Emulator](https://docs.aws.amazon.com/emulator/latest/userguide/getting-started-docker.html).
The Dockerfile picks the x86_64 or aarch64 RPM automatically from the build platform.

## Build

```sh
docker build -t aws-emulator .
```

## Run

```sh
mkdir -p ~/.aws/emulator
PORT=9297
docker run --rm --memory=2g --memory-swap=2g -p 127.0.0.1:$PORT:$PORT \
  -e HOME="$HOME" -v "$HOME/.aws/emulator:$HOME/.aws/emulator" \
  aws-emulator -p $PORT
```

Health check (the endpoint is HTTPS, signed by the emulator's own CA):

```sh
curl --cacert ~/.aws/emulator/9297/ca.pem https://127.0.0.1:9297/__admin/health
```

On Linux, add `--user "$(id -u):$(id -g)"` after `docker run`.
