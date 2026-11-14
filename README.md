# AWS Emulator Docker

[AWS Emulator](https://docs.aws.amazon.com/emulator/latest/userguide/getting-started-docker.html)용 Docker 이미지입니다.
`Dockerfile` 하나로 x86_64(Intel/AMD Linux, Windows, Intel Mac)와
aarch64(Apple silicon, Graviton 등 Arm 머신)를 모두 지원합니다. 빌드 플랫폼에 맞는 RPM을
자동으로 설치하므로 아키텍처별 Dockerfile을 따로 관리할 필요가 없습니다.

## RPM 패키지

이미지는 빌드 시점에 해당 아키텍처의 최신 LTS 패키지를 설치합니다.

| 아키텍처 | Docker 플랫폼 | RPM |
| --- | --- | --- |
| x86_64 | `linux/amd64` | [aws-emulator-x86_64.rpm](https://downloads.aws.com/aws-emulator/packages/aws-emulator/LTS/latest/aws-emulator-x86_64.rpm) |
| aarch64 | `linux/arm64` | [aws-emulator-aarch64.rpm](https://downloads.aws.com/aws-emulator/packages/aws-emulator/LTS/latest/aws-emulator-aarch64.rpm) |

지원 기능과 제한 사항은 [docs/FEATURES.md](docs/FEATURES.md)에 정리되어 있습니다.

## 참고 문서

- [Docker로 시작하기](https://docs.aws.amazon.com/emulator/latest/userguide/getting-started-docker.html) — 이 이미지가 따르는 문서
- [Linux에서 시작하기](https://docs.aws.amazon.com/emulator/latest/userguide/getting-started-linux.html) — RPM을 직접 설치하는 방법
- [AWS Emulator 설정](https://docs.aws.amazon.com/emulator/latest/userguide/setting-up.html) — 사전 준비 사항
- [SDK를 로컬 에뮬레이터에 연결하기](https://docs.aws.amazon.com/emulator/latest/userguide/point-sdk-to-emulator.html#point-sdk-env)
- [명령 레퍼런스](https://docs.aws.amazon.com/emulator/latest/userguide/cli-reference.html) — `docker run` 뒤에 붙일 수 있는 옵션
- [텔레메트리 끄기](https://docs.aws.amazon.com/emulator/latest/userguide/telemetry.html#telemetry-opt-out)

## 빌드

```sh
docker build -t aws-emulator .
```

현재 사용 중인 머신의 아키텍처로 빌드됩니다. 다른 아키텍처로 빌드하려면 플랫폼을
지정합니다. 빌드한 이미지를 다른 CPU에서 실행하려면 QEMU 에뮬레이션이 필요하며,
Docker Desktop에는 기본으로 포함되어 있습니다.

```sh
docker build --platform linux/amd64 -t aws-emulator .   # x86_64
docker build --platform linux/arm64 -t aws-emulator .   # aarch64
```

## 실행

```sh
mkdir -p ~/.aws/emulator
PORT=9297
docker run --rm --memory=2g --memory-swap=2g -p 127.0.0.1:$PORT:$PORT \
  -e HOME="$HOME" -v "$HOME/.aws/emulator:$HOME/.aws/emulator" \
  aws-emulator -p $PORT
```

Linux에서는 `docker run` 바로 뒤에 `--user "$(id -u):$(id -g)"`를 추가합니다.

상태 확인(엔드포인트는 HTTPS이며 에뮬레이터 자체 CA로 서명됩니다):

```sh
curl --cacert ~/.aws/emulator/9297/ca.pem https://127.0.0.1:9297/__admin/health
```

## 테스트

`test/test.sh`는 이미지를 빌드하고 아키텍처, 설치된 RPM, 실행 사용자, 포트,
entrypoint를 검사한 뒤, 위의 실행 방법대로 컨테이너를 띄워 상태 확인 엔드포인트가
응답할 때까지 기다립니다. Docker, bash, curl만 있으면 됩니다.

```sh
test/test.sh
```

```sh
PLATFORM=linux/arm64 test/test.sh
```

`PORT`, `IMAGE`, `BUILD_OPTS`(`docker build` 추가 옵션), `SKIP_BUILD=1` 환경 변수도
사용할 수 있습니다. GitHub Actions는 x86_64와 aarch64 네이티브 러너에서 이 스크립트를
실행합니다(`.github/workflows/test.yml`).
