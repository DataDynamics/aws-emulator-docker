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

지원 기능과 제한 사항은 [docs/FEATURES.md](docs/FEATURES.md)에, 지원 서비스 전체 목록은 [docs/SERVICES.md](docs/SERVICES.md)에 정리되어 있습니다.

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

## 지원하는 AWS 서비스

RPM 1.0.351-1에는 AWS 서비스 436개의 API가 들어 있습니다. 전체 목록은
[docs/SERVICES.md](docs/SERVICES.md)에 있습니다.

- **목록의 근거**: RPM의 빌드 커밋에 해당하는 [aws-emulator 소스](https://github.com/aws/aws-emulator)의 서비스 구성입니다.
- **지원 수준은 서비스마다 다름**: 목록에 있어도 모든 작업이 구현된 것은 아니며, 구현되지 않은 작업은 HTTP 501 `NotImplemented`를 반환합니다.
- **실제 응답 확인**: 이 이미지로 띄운 에뮬레이터에 서비스마다 조회 작업 하나씩을 보냈을 때 257개 서비스가 성공했고, 87개는 그 작업이 501이었습니다. 나머지는 인자·구독 관련 오류를 반환했거나 확인할 작업이 없었습니다.
- **충실도 테스트**: AWS가 공개한 [충실도 테스트](https://github.com/aws/aws-emulator-evaluation-suite) 29,676개가 351개 서비스를 다룹니다. 통과 점수는 [릴리스 페이지](https://github.com/aws/aws-emulator/releases)에서 확인합니다.

충실도 테스트가 많은 상위 30개 서비스입니다. 테스트가 많을수록 AWS와 같은 동작이 폭넓게 검증됩니다.
숫자는 그 서비스가 참여하는 테스트 개수이며, 통과 개수가 아닙니다.

| 서비스 | Boto3 / AWS CLI 이름 | 충실도 테스트 수 |
| --- | --- | ---: |
| AWS Lambda | `lambda` | 2,470 |
| AWS CloudFormation | `cloudformation` | 1,945 |
| Amazon Simple Storage Service | `s3` | 1,677 |
| Amazon Elastic Compute Cloud | `ec2` | 1,430 |
| Amazon DynamoDB | `dynamodb` | 1,425 |
| Amazon Simple Queue Service | `sqs` | 1,418 |
| Amazon CloudWatch | `cloudwatch` | 1,090 |
| Amazon API Gateway | `apigateway` | 993 |
| Amazon CloudWatch Logs | `logs` | 920 |
| AWS Step Functions | `stepfunctions` | 858 |
| Amazon EventBridge | `events` | 840 |
| AWS Identity and Access Management | `iam` | 785 |
| Amazon Cognito Identity Provider | `cognito-idp` | 758 |
| Amazon EC2 Container Service | `ecs` | 683 |
| Amazon CloudFront | `cloudfront` | 570 |
| Amazon Simple Notification Service | `sns` | 533 |
| Elastic Load Balancing | `elbv2` | 516 |
| Amazon Relational Database Service | `rds` | 512 |
| Amazon Simple Systems Manager (SSM) | `ssm` | 505 |
| AWS Glue | `glue` | 486 |
| Amazon SageMaker Service | `sagemaker` | 477 |
| AWS AppSync | `appsync` | 424 |
| Amazon Athena | `athena` | 379 |
| Auto Scaling | `autoscaling` | 377 |
| AWS Key Management Service | `kms` | 373 |
| Amazon Elastic Container Registry | `ecr` | 363 |
| AWS Secrets Manager | `secretsmanager` | 360 |
| Amazon Cognito Identity | `cognito-identity` | 337 |
| Amazon OpenSearch Service | `opensearch` | 320 |
| Amazon Kinesis | `kinesis` | 319 |

## SDK에서 사용하기

에뮬레이터를 [실행](#실행)한 뒤, 코드를 실행할 셸에서 환경 변수만 설정하면 AWS CLI와 SDK가
AWS 대신 에뮬레이터로 요청을 보냅니다. 코드에는 엔드포인트나 자격 증명을 적지 않아도 됩니다.
아래 내용은 AWS 문서 [SDK를 에뮬레이터에 연결하기](https://docs.aws.amazon.com/emulator/latest/userguide/point-sdk-to-emulator.html)의
절차와 예제를 따르며, Python·Java 예제는 이 이미지로 띄운 에뮬레이터(1.0.351)에서 실행해 확인했습니다.

### 환경 변수 설정

포트를 바꿨다면 각 값의 `9297`을 그 포트로 바꿉니다.

```sh
export AWS_ENDPOINT_URL=https://127.0.0.1:9297
export AWS_SHARED_CREDENTIALS_FILE=~/.aws/emulator/9297/emulator_credentials
export AWS_CONFIG_FILE=~/.aws/emulator/9297/config
export AWS_CA_BUNDLE=~/.aws/emulator/9297/ca.pem
export AWS_EC2_METADATA_DISABLED=true
export AWS_DISABLE_HOST_PREFIX_INJECTION=true
export AWS_REGION=us-east-1
export AWS_DEFAULT_REGION=us-east-1
```

실제 AWS 자격 증명을 담은 변수는 해제합니다. 남아 있으면 SDK가 그 키로 서명하고,
에뮬레이터는 요청을 거부합니다.

```sh
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_PROFILE
```

| 변수 | 역할 |
| --- | --- |
| `AWS_ENDPOINT_URL` | 모든 서비스 요청을 에뮬레이터로 보냅니다. `localhost`가 아니라 `127.0.0.1`을 써야 S3 요청이 도달합니다. |
| `AWS_SHARED_CREDENTIALS_FILE` | 에뮬레이터가 이번 실행용으로 만든 액세스 키입니다. 재시작하면 바뀝니다. |
| `AWS_CONFIG_FILE` | 에뮬레이터가 만든 프로필입니다. 이 셸에서는 기존 `~/.aws/config` 설정이 적용되지 않습니다. |
| `AWS_CA_BUNDLE` | AWS CLI, Python(Boto3), Go SDK가 에뮬레이터 인증서를 신뢰하게 합니다. Java는 [아래](#java-aws-sdk-for-java-2x) 설정이 따로 필요합니다. |
| `AWS_EC2_METADATA_DISABLED` | EC2 인스턴스에서 테스트할 때 실제 자격 증명을 가져오지 않게 합니다. |
| `AWS_DISABLE_HOST_PREFIX_INJECTION` | AWS CLI와 Boto3가 호스트 이름 앞에 접두사(`data-` 등)를 붙이지 않게 합니다. |

스크립트에서는 에뮬레이터가 준비될 때까지 기다린 뒤 테스트를 실행합니다.

```sh
for i in $(seq 30); do
  curl -sf --cacert ~/.aws/emulator/9297/ca.pem https://127.0.0.1:9297/__admin/health && break
  sleep 1
done
```

### AWS CLI로 확인

요청이 에뮬레이터로 가는지 확인합니다. `Account`가 `000000000000`이면 에뮬레이터이고,
본인 계정 ID가 보이면 요청이 실제 AWS로 가고 있는 것입니다.

```console
$ aws sts get-caller-identity
{
    "UserId": "AIDAH5I7GEMO7ADXNFAZU",
    "Account": "000000000000",
    "Arn": "arn:aws:iam::000000000000:user/emulator"
}
```

에뮬레이터는 만든 리소스를 기억합니다.

```console
$ aws s3api create-bucket --bucket emulator-demo-bucket
$ aws s3api list-buckets --query 'Buckets[].Name'
[
    "emulator-demo-bucket"
]
```

잘못된 요청에는 AWS와 같은 오류를 돌려줍니다. DynamoDB 테이블 이름은 3자 이상이어야 합니다.

```console
$ aws dynamodb create-table --table-name ab \
    --attribute-definitions AttributeName=id,AttributeType=S \
    --key-schema AttributeName=id,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST
An error occurred (ValidationException) when calling the CreateTable operation: 1 validation error detected: Value 'ab' at 'tableName' failed to satisfy constraint: Member must have length greater than or equal to 3
```

> AWS 문서 예제의 버킷 이름 `amzn-s3-demo-bucket`은 1.0.351에서 `InvalidBucketName`으로
> 거부되어, 이 문서의 예제는 `emulator-demo-bucket`을 사용합니다.

### Python (Boto3)

```sh
pip install boto3
```

Boto3는 위 환경 변수를 모두 읽으므로 추가 설정이 없습니다. AWS 문서의 가장 짧은 예제는 다음과 같습니다.

```python
import boto3

s3 = boto3.client("s3")
print(s3.list_buckets()["Buckets"])
```

STS, S3, DynamoDB를 함께 쓰는 예제입니다(`example.py`).

```python
import boto3
from botocore.exceptions import ClientError

# 1) 에뮬레이터에 연결되었는지 확인: 계정이 000000000000 이어야 합니다.
identity = boto3.client("sts").get_caller_identity()
print("account:", identity["Account"], identity["Arn"])

# 2) S3: 버킷 생성 → 객체 쓰기 → 읽기
s3 = boto3.client("s3")
s3.create_bucket(Bucket="emulator-demo-bucket")
s3.put_object(Bucket="emulator-demo-bucket", Key="hello.txt", Body=b"hi")
body = s3.get_object(Bucket="emulator-demo-bucket", Key="hello.txt")["Body"].read()
print("buckets:", [b["Name"] for b in s3.list_buckets()["Buckets"]])
print("object:", body.decode())

# 3) DynamoDB: 테이블 생성 → 항목 쓰기 → 읽기
dynamodb = boto3.client("dynamodb")
dynamodb.create_table(
    TableName="demo-table",
    AttributeDefinitions=[{"AttributeName": "id", "AttributeType": "S"}],
    KeySchema=[{"AttributeName": "id", "KeyType": "HASH"}],
    BillingMode="PAY_PER_REQUEST",
)
dynamodb.get_waiter("table_exists").wait(TableName="demo-table")
dynamodb.put_item(TableName="demo-table", Item={"id": {"S": "1"}, "name": {"S": "emulator"}})
item = dynamodb.get_item(TableName="demo-table", Key={"id": {"S": "1"}})["Item"]
print("item:", item)

# 4) 잘못된 요청은 AWS와 같은 오류를 돌려줍니다(테이블 이름은 3자 이상).
try:
    dynamodb.create_table(
        TableName="ab",
        AttributeDefinitions=[{"AttributeName": "id", "AttributeType": "S"}],
        KeySchema=[{"AttributeName": "id", "KeyType": "HASH"}],
        BillingMode="PAY_PER_REQUEST",
    )
except ClientError as e:
    print("error:", e.response["Error"]["Code"], "-", e.response["Error"]["Message"])
```

```console
$ python example.py
account: 000000000000 arn:aws:iam::000000000000:user/emulator
buckets: ['emulator-demo-bucket']
object: hi
item: {'id': {'S': '1'}, 'name': {'S': 'emulator'}}
error: ValidationException - 1 validation error detected: Value 'ab' at 'tableName' failed to satisfy constraint: Member must have length greater than or equal to 3
```

환경 변수 없이 코드에서 직접 지정할 수도 있습니다. 실제 AWS를 함께 호출하는 프로세스에서
에뮬레이터용 클라이언트만 따로 만들 때 씁니다.

```python
import configparser
import os

import boto3

PORT = 9297
home = os.path.expanduser(f"~/.aws/emulator/{PORT}")

credentials = configparser.ConfigParser()
credentials.read(os.path.join(home, "emulator_credentials"))

s3 = boto3.client(
    "s3",
    endpoint_url=f"https://127.0.0.1:{PORT}",
    region_name="us-east-1",
    aws_access_key_id=credentials["default"]["aws_access_key_id"],
    aws_secret_access_key=credentials["default"]["aws_secret_access_key"],
    verify=os.path.join(home, "ca.pem"),
)
print(s3.list_buckets()["Buckets"])
```

호스트 접두사를 코드에서 끄려면 `Config(inject_host_prefix=False)`로 클라이언트를 만듭니다.

### Java (AWS SDK for Java 2.x)

Java SDK도 엔드포인트, 자격 증명, 리전은 같은 환경 변수에서 읽습니다. 다만 Java는 `ca.pem`을
읽지 않으므로, 에뮬레이터가 같은 폴더에 만드는 `truststore.p12`(비밀번호 없는 PKCS12)를 JVM에 지정해야 합니다.

```sh
export JAVA_TOOL_OPTIONS="-Djavax.net.ssl.trustStore=$HOME/.aws/emulator/9297/truststore.p12 -Djavax.net.ssl.trustStoreType=PKCS12"
```

이 설정은 JVM의 기본 트러스트 스토어를 대체합니다. 그 셸에서 띄운 모든 JVM에 적용되어
Maven·Gradle의 의존성 다운로드가 `PKIX path building failed`로 실패하므로, 아래 예제처럼
테스트나 예제를 실행하는 JVM에만 옵션을 넘기는 편이 안전합니다(Gradle은 `test` 태스크의
`jvmArgs`, Maven Surefire는 `argLine`).

`pom.xml`:

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0">
  <modelVersion>4.0.0</modelVersion>
  <groupId>example</groupId>
  <artifactId>aws-emulator-example</artifactId>
  <version>1.0</version>

  <properties>
    <maven.compiler.release>17</maven.compiler.release>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <emulator.port>9297</emulator.port>
  </properties>

  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>software.amazon.awssdk</groupId>
        <artifactId>bom</artifactId>
        <version>2.59.1</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>

  <dependencies>
    <dependency><groupId>software.amazon.awssdk</groupId><artifactId>s3</artifactId></dependency>
    <dependency><groupId>software.amazon.awssdk</groupId><artifactId>dynamodb</artifactId></dependency>
    <dependency><groupId>software.amazon.awssdk</groupId><artifactId>sts</artifactId></dependency>
    <dependency><groupId>org.slf4j</groupId><artifactId>slf4j-nop</artifactId><version>2.0.17</version></dependency>
  </dependencies>

  <build>
    <plugins>
      <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>exec-maven-plugin</artifactId>
        <version>3.7.0</version>
        <configuration>
          <executable>java</executable>
          <arguments>
            <!-- 에뮬레이터 인증서는 예제를 실행하는 JVM에만 적용합니다. -->
            <argument>-Djavax.net.ssl.trustStore=${user.home}/.aws/emulator/${emulator.port}/truststore.p12</argument>
            <argument>-Djavax.net.ssl.trustStoreType=PKCS12</argument>
            <argument>-classpath</argument>
            <classpath/>
            <argument>Example</argument>
          </arguments>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
```

`src/main/java/Example.java`:

```java
import java.util.Map;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.AttributeValue;
import software.amazon.awssdk.services.dynamodb.model.BillingMode;
import software.amazon.awssdk.services.dynamodb.model.DynamoDbException;
import software.amazon.awssdk.services.dynamodb.model.KeyType;
import software.amazon.awssdk.services.dynamodb.model.ScalarAttributeType;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.sts.StsClient;

public class Example {
    public static void main(String[] args) {
        // 엔드포인트, 자격 증명, 리전은 환경 변수에서 읽으므로 코드에 적지 않습니다.
        try (StsClient sts = StsClient.create();
             S3Client s3 = S3Client.create();
             DynamoDbClient dynamodb = DynamoDbClient.create()) {

            // 1) 에뮬레이터에 연결되었는지 확인: 계정이 000000000000 이어야 합니다.
            var identity = sts.getCallerIdentity();
            System.out.println("account: " + identity.account() + " " + identity.arn());

            // 2) S3: 버킷 생성 → 객체 쓰기 → 읽기
            String bucket = "emulator-demo-bucket-java";
            s3.createBucket(b -> b.bucket(bucket));
            s3.putObject(b -> b.bucket(bucket).key("hello.txt"), RequestBody.fromString("hi"));
            String body = s3.getObjectAsBytes(b -> b.bucket(bucket).key("hello.txt")).asUtf8String();
            System.out.println("buckets: " + s3.listBuckets().buckets().stream().map(b -> b.name()).toList());
            System.out.println("object: " + body);

            // 3) DynamoDB: 테이블 생성 → 항목 쓰기 → 읽기
            String table = "demo-table-java";
            createTable(dynamodb, table);
            dynamodb.waiter().waitUntilTableExists(b -> b.tableName(table));
            dynamodb.putItem(b -> b.tableName(table).item(Map.of(
                    "id", AttributeValue.fromS("1"),
                    "name", AttributeValue.fromS("emulator"))));
            var item = dynamodb.getItem(b -> b.tableName(table)
                    .key(Map.of("id", AttributeValue.fromS("1")))).item();
            System.out.println("item: " + item);

            // 4) 잘못된 요청은 AWS와 같은 오류를 돌려줍니다(테이블 이름은 3자 이상).
            try {
                createTable(dynamodb, "ab");
            } catch (DynamoDbException e) {
                System.out.println("error: " + e.awsErrorDetails().errorCode()
                        + " - " + e.awsErrorDetails().errorMessage());
            }
        }
    }

    private static void createTable(DynamoDbClient dynamodb, String name) {
        dynamodb.createTable(b -> b.tableName(name)
                .attributeDefinitions(a -> a.attributeName("id").attributeType(ScalarAttributeType.S))
                .keySchema(k -> k.attributeName("id").keyType(KeyType.HASH))
                .billingMode(BillingMode.PAY_PER_REQUEST));
    }
}
```

```console
$ mvn -q compile exec:exec
account: 000000000000 arn:aws:iam::000000000000:user/emulator
buckets: [emulator-demo-bucket-java]
object: hi
item: {id=AttributeValue(S=1), name=AttributeValue(S=emulator)}
error: ValidationException - 1 validation error detected: Value 'ab' at 'tableName' failed to satisfy constraint: Member must have length greater than or equal to 3
```

호스트 접두사를 쓰는 작업(Cloud Map `DiscoverInstances`, Step Functions `StartSyncExecution` 등)을
호출한다면 Java에서는 환경 변수 대신 클라이언트 설정으로 끕니다.

```java
ServiceDiscoveryClient client = ServiceDiscoveryClient.builder()
        .overrideConfiguration(c -> c.putAdvancedOption(
                SdkAdvancedClientOption.DISABLE_HOST_PREFIX_INJECTION, true))
        .build();
```

### 주의 사항

- **테스트 스크립트 안에서 변수 설정**: `AWS_ENDPOINT_URL`이 없으면 코드는 찾을 수 있는 자격 증명으로 실제 AWS를 호출합니다.
- **재시작 후에는 새 키와 인증서**: 경로를 가리키는 설정은 그대로 동작하지만, 키나 인증서를 복사해 두었다면 다시 복사해야 합니다.
- **다른 HTTPS 서버와 함께 쓸 때**: `AWS_CA_BUNDLE`과 Java 트러스트 스토어는 기본 인증서를 대체하므로, 한 프로세스에서 에뮬레이터와 AWS를 모두 호출하려면 시스템 인증서에 `ca.pem`을 더한 번들을 써야 합니다.
- **S3 Control 미지원**: SDK가 계정 ID를 호스트 이름에 넣기 때문에 요청이 에뮬레이터에 도달하지 않습니다.
- **Windows와 다른 언어**: PowerShell 명령과 JavaScript, Go, Rust, .NET 설정은 [AWS 문서](https://docs.aws.amazon.com/emulator/latest/userguide/point-sdk-to-emulator.html#point-sdk-ca)를 참고합니다.

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
