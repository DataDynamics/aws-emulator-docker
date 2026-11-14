# AWS Emulator RPM 지원 기능

RPM 패키지(`aws-emulator` 1.0.351-1 기준)에 포함된 내용과 지원 기능을 정리한 문서입니다.
설치된 패키지, `aws-emulator --help` 출력,
[AWS Emulator 사용자 가이드](https://docs.aws.amazon.com/emulator/latest/userguide/what-is-service.html)를 근거로 했습니다.
RPM에는 `aws-emulator` 실행 파일 하나만 들어 있고, 이 프로그램이 로컬에서 AWS API 엔드포인트 역할을 합니다.

## 패키지 구성

- `/usr/bin/aws-emulator`와 `/opt/aws-emulator/bin/aws-emulator`: 실행 파일입니다. 하위 명령 없이 옵션만 받습니다.
- `/opt/aws-emulator/THIRD_PARTY_LICENSES`: 서드파티 라이선스 고지입니다.
- 의존성은 glibc뿐이고, 설치 크기는 약 1GB입니다.

## 핵심 기능

- **AWS API 에뮬레이션**: AWS 계정이나 AWS 리소스 없이 로컬에서 AWS API 요청을 처리합니다.
  [AWS API 모델 저장소](https://github.com/aws/api-models-aws)에 모델이 있는 서비스의 API가 대상입니다.
- **상태 유지**: 만든 리소스(예: S3 버킷)를 메모리에 보관해 이후 조회에서 돌려줍니다. 종료하면 모두 사라집니다.
- **AWS와 같은 오류 응답**: 잘못된 요청에는 AWS와 같은 오류 코드와 메시지를 돌려주는 것을 목표로 합니다(예: DynamoDB 테이블 이름 길이 검증).
- **미구현 API**: 아직 구현되지 않은 작업은 HTTP 501 `NotImplemented`를 반환합니다.
- **CLI·SDK 연동**: 환경 변수로 엔드포인트만 에뮬레이터로 바꾸면 되고, 코드 수정은 필요 없습니다.

## 명령 옵션

| 옵션 | 기본값 | 설명 |
| --- | --- | --- |
| `-b`, `--bind <ip>` | `127.0.0.1` | 수신 IP 주소입니다. 컨테이너에서는 `0.0.0.0`을 씁니다. |
| `-p`, `--port <port>` | `9297` | HTTPS 포트입니다. `0`이면 빈 포트를 자동 선택합니다. |
| `-a`, `--auth on\|off` | `on` | SigV4 서명 검증 여부입니다. |
| `-t`, `--telemetry on\|off` | `on` | 익명 사용 통계 전송 여부입니다. |
| `--idle-timeout <초>` | 없음 | API 호출이 이 시간 동안 없으면 자동 종료합니다. |
| `-v`, `--version` | | 버전, 릴리스 날짜, 커밋을 출력합니다. |
| `-h`, `--help` | | 도움말을 출력합니다. |

환경 변수 `EMULATOR_BIND_ADDRESS`, `EMULATOR_DATA_PORT`, `EMULATOR_TELEMETRY`, `EMULATOR_CONFIG`로도 설정할 수 있습니다.

## 보안·인증

- **HTTPS 전용**: 시작할 때마다 자체 인증서를 새로 만듭니다.
- **실행별 자격 증명**: 시작할 때마다 새 액세스 키를 만들며, 그 실행에서만 유효합니다.
- **SigV4 검증**: 서명 헤더와 presigned URL을 모두 받습니다. 에뮬레이터 안에서 IAM `CreateAccessKey`나 STS로 만든 키도 사용할 수 있습니다.
- **단일 계정**: 계정 ID는 항상 `000000000000`입니다.

## 생성 파일과 관리 경로

시작하면 `~/.aws/emulator/<포트>/`에 아래 파일을 쓰고, 정상 종료(Ctrl+C, `SIGTERM`, 유휴 타임아웃) 시 삭제합니다.

| 파일 | 내용 |
| --- | --- |
| `emulator_credentials` | 이번 실행의 액세스 키(인증이 켜져 있을 때만 생성) |
| `config` | `endpoint_url`, `ca_bundle`, 리전(`us-east-1`)이 설정된 AWS 프로필 |
| `ca.pem` | HTTPS 인증서 |
| `truststore.p12` | Java용 트러스트 스토어 |

관리 경로는 `GET /__admin/health` 하나뿐이며 정상일 때 200과 `ok`를 반환합니다.
상태 초기화 경로는 없으므로 초기화하려면 재시작해야 합니다. 로그는 표준 출력에 JSON 라인으로 나옵니다.

## 제한 사항

- **보안 테스트 불가**: IAM 정책, S3 버킷 정책, KMS 키 정책을 AWS처럼 평가하지 않습니다.
- **리전·계정 분리 없음**: 에뮬레이터 하나에 리전 하나, 계정 하나로 써야 합니다. 여러 리전은 포트를 달리해 여러 개를 띄웁니다.
- **서비스별 충실도 차이**: 리소스 생성·조회·삭제 같은 컨트롤 플레인 API가 가장 잘 맞습니다. 데이터 플레인과 CloudFormation·Terraform·CDK 지원은 서비스마다 다릅니다.
- **신뢰할 수 있는 코드만**: 함수 코드 등을 실행할 때 격리하지 않고 사용자 권한으로 실행합니다.
- **테스트 용도 전용**: 프로덕션, 장시간 실행, 부하 테스트 용도가 아닙니다.

서비스별 지원 수준은 릴리스마다 [GitHub 릴리스 페이지](https://github.com/aws/aws-emulator/releases)에 충실도 점수로 공개됩니다.

## 참고 문서

- [AWS Emulator란?](https://docs.aws.amazon.com/emulator/latest/userguide/what-is-service.html)
- [충실도(Fidelity)](https://docs.aws.amazon.com/emulator/latest/userguide/fidelity.html)
- [명령 레퍼런스](https://docs.aws.amazon.com/emulator/latest/userguide/cli-reference.html)
- [보안](https://docs.aws.amazon.com/emulator/latest/userguide/security.html)
- [버전과 호환성](https://docs.aws.amazon.com/emulator/latest/userguide/versioning.html)
- [텔레메트리](https://docs.aws.amazon.com/emulator/latest/userguide/telemetry.html)
