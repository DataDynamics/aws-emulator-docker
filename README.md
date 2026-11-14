# AWS Emulator Docker

Docker image for [AWS Emulator](https://docs.aws.amazon.com/emulator/latest/userguide/getting-started-docker.html).
A single `Dockerfile` covers both x86_64 (Intel/AMD Linux, Windows, Intel Macs) and
aarch64 (Apple silicon, Graviton and other Arm machines): it installs the RPM that
matches the build platform, so there is no per-architecture Dockerfile to keep in sync.

## RPM packages

The image installs the latest LTS package for its architecture at build time.

| Architecture | Docker platform | RPM |
| --- | --- | --- |
| x86_64 | `linux/amd64` | [aws-emulator-x86_64.rpm](https://downloads.aws.com/aws-emulator/packages/aws-emulator/LTS/latest/aws-emulator-x86_64.rpm) |
| aarch64 | `linux/arm64` | [aws-emulator-aarch64.rpm](https://downloads.aws.com/aws-emulator/packages/aws-emulator/LTS/latest/aws-emulator-aarch64.rpm) |

## References

- [Getting started with Docker](https://docs.aws.amazon.com/emulator/latest/userguide/getting-started-docker.html) — the page this image follows
- [Getting started on Linux](https://docs.aws.amazon.com/emulator/latest/userguide/getting-started-linux.html) — installing the RPM directly
- [Setting up AWS Emulator](https://docs.aws.amazon.com/emulator/latest/userguide/setting-up.html) — prerequisites
- [Pointing your SDK at a local emulator](https://docs.aws.amazon.com/emulator/latest/userguide/point-sdk-to-emulator.html#point-sdk-env)
- [Command reference](https://docs.aws.amazon.com/emulator/latest/userguide/cli-reference.html) — options you can append to `docker run`
- [Turning telemetry off](https://docs.aws.amazon.com/emulator/latest/userguide/telemetry.html#telemetry-opt-out)

## Build

```sh
docker build -t aws-emulator .
```

This builds for the machine you are on. To build for the other architecture, name
the platform (running the result on a different CPU needs QEMU emulation, which
Docker Desktop includes):

```sh
docker build --platform linux/amd64 -t aws-emulator .   # x86_64
docker build --platform linux/arm64 -t aws-emulator .   # aarch64
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

## Test

`test/test.sh` builds the image, checks its architecture, installed RPM, user,
port and entrypoint, then starts a container as shown above and waits for the
health endpoint. It needs only Docker, bash and curl.

```sh
test/test.sh
```

```sh
PLATFORM=linux/arm64 test/test.sh
```

`PORT`, `IMAGE`, `BUILD_OPTS` (extra `docker build` options) and `SKIP_BUILD=1`
are also honored. GitHub Actions runs the script on native x86_64 and aarch64
runners (`.github/workflows/test.yml`).
