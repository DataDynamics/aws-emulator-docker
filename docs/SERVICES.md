# AWS Emulator 지원 서비스 목록

RPM `aws-emulator` 1.0.351-1에 포함된 AWS 서비스 436개의 목록입니다.

## 목록을 만든 방법

- **서비스 목록**: `aws-emulator --version`이 알려 주는 빌드 커밋(`0c052e93`)의
  [aws-emulator 소스](https://github.com/aws/aws-emulator)에서 워크스페이스에 포함된 서비스 크레이트를 뽑았습니다.
  에뮬레이터는 서비스마다 크레이트 하나를 두고, 모두를 하나의 엔드포인트로 제공합니다.
- **충실도 테스트 수**: [aws-emulator-evaluation-suite](https://github.com/aws/aws-emulator-evaluation-suite)의
  `manifest.jsonl`(2026-11-14 기준, 전체 29,676개)에서 그 서비스가 참여하는 테스트 수입니다.
  여러 서비스를 함께 쓰는 테스트는 각 서비스에 한 번씩 셉니다. 테스트 개수이지 통과 개수가 아니며,
  통과 점수는 [릴리스 페이지](https://github.com/aws/aws-emulator/releases)에 공개됩니다.
- **조회 호출 결과**: 이 저장소의 이미지로 띄운 에뮬레이터에 Boto3로 서비스마다 필수 인자가 없는
  조회 작업(`List*`/`Describe*`/`Get*`) 하나를 보낸 결과입니다.

## 읽는 법

목록에 있다는 것은 그 서비스의 API가 에뮬레이터에 연결되어 있다는 뜻이고, 모든 작업이 구현되었다는
뜻은 아닙니다. 구현되지 않은 작업은 HTTP 501 `NotImplemented`를 반환합니다.

조회 호출 결과는 서비스당 작업 하나만 확인한 것입니다. 예를 들어 Amazon EC2는 확인한 작업이
501이지만 충실도 테스트가 가장 많은 서비스입니다. 서비스의 지원 수준은 충실도 테스트 수와
릴리스의 점수로 판단하고, 이 열은 참고로만 보세요.

| 조회 호출 결과 | 서비스 수 |
| --- | --- |
| 성공 | 257 |
| 501 미구현(확인한 작업 하나가 미구현) | 87 |
| AWS 형식의 오류 응답(인자 검증, 구독·옵트인 필요 등) 또는 호출 실패 | 23 |
| 확인하지 않음(필수 인자 없는 조회 작업이 없거나 Boto3에 없는 서비스) | 69 |

충실도 테스트가 하나 이상 있는 서비스는 351개입니다.

## 전체 목록

| 서비스 | Boto3 / AWS CLI 이름 | 충실도 테스트 수 | 조회 호출 결과 |
| --- | --- | ---: | --- |
| Access Analyzer | `accessanalyzer` | 29 | `ListAnalyzers` → 성공 |
| Account Access | `account-access` | — | `ListApplications` → 501 미구현 |
| Account Access Runtime | `account-access-runtime` | — | — |
| Agent Registry | `agent-registry` | 12 | — |
| Agent Registry Control | `agent-registry-control` | 21 | `ListRegistries` → 501 미구현 |
| Agents for Amazon Bedrock | `bedrock-agent` | 65 | `ListAgents` → 성공 |
| Agents for Amazon Bedrock Runtime | `bedrock-agent-runtime` | 142 | `ListSessions` → 성공 |
| Amazon API Gateway | `apigateway` | 993 | `GetAccount` → 성공 |
| Amazon AppConfig | `appconfig` | 230 | `ListApplications` → 성공 |
| Amazon Appflow | `appflow` | 24 | `ListConnectorEntities` → 501 미구현 |
| Amazon AppIntegrations Service | `appintegrations` | 23 | `ListApplications` → 501 미구현 |
| Amazon AppStream | `appstream` | 26 | `ListExportImageTasks` → 501 미구현 |
| Amazon Athena | `athena` | 379 | `ListApplicationDPUSizes` → 501 미구현 |
| Amazon Augmented AI Runtime | `sagemaker-a2i-runtime` | — | — |
| Amazon Aurora DSQL | `dsql` | 51 | `ListClusters` → 성공 |
| Amazon Bedrock | `bedrock` | 203 | `ListAdvancedPromptOptimizationJobs` → 501 미구현 |
| Amazon Bedrock AgentCore | `bedrock-agentcore` | 66 | `ListABTests` → 성공 |
| Amazon Bedrock AgentCore Control | `bedrock-agentcore-control` | 132 | `ListAgentRuntimes` → 성공 |
| Amazon Bedrock Runtime | `bedrock-runtime` | 94 | `ListAsyncInvokes` → 성공 |
| Amazon Chime | `chime` | — | `ListAccounts` → 성공 |
| Amazon Chime SDK Identity | `chime-sdk-identity` | 24 | `ListAppInstances` → 성공 |
| Amazon Chime SDK Media Pipelines | `chime-sdk-media-pipelines` | 24 | `ListMediaCapturePipelines` → 성공 |
| Amazon Chime SDK Meetings | `chime-sdk-meetings` | 25 | — |
| Amazon Chime SDK Messaging | `chime-sdk-messaging` | 12 | `GetMessagingSessionEndpoint` → 501 미구현 |
| Amazon Chime SDK Voice | `chime-sdk-voice` | — | `ListAvailableVoiceConnectorRegions` → 501 미구현 |
| Amazon CloudDirectory | `clouddirectory` | — | `ListDevelopmentSchemaArns` → 501 미구현 |
| Amazon CloudFront | `cloudfront` | 570 | `ListAnycastIpLists` → 성공 |
| Amazon CloudFront KeyValueStore | `cloudfront-keyvaluestore` | 46 | — |
| Amazon CloudHSM | `cloudhsm` | — | `ListAvailableZones` → 501 미구현 |
| Amazon CloudSearch | `cloudsearch` | — | `ListDomainNames` → 성공 |
| Amazon CloudSearch Domain | `cloudsearchdomain` | — | — |
| Amazon CloudWatch | `cloudwatch` | 1090 | `ListAlarmMuteRules` → 성공 |
| Amazon CloudWatch Application Insights | `application-insights` | 4 | `ListApplications` → 성공 |
| Amazon CloudWatch Application Signals | `application-signals` | 27 | `ListGroupingAttributeDefinitions` → 성공 |
| Amazon CloudWatch Events | `events` | — | — |
| Amazon CloudWatch Internet Monitor | `internetmonitor` | 23 | `ListInternetEvents` → 성공 |
| Amazon CloudWatch Logs | `logs` | 920 | `ListAnomalies` → 성공 |
| Amazon CloudWatch Network Monitor | `networkmonitor` | 43 | `ListMonitors` → 성공 |
| Amazon CodeCatalyst | `codecatalyst` | — | `ListAccessTokens` → 호출 실패 |
| Amazon CodeGuru Profiler | `codeguruprofiler` | 82 | `ListProfilingGroups` → 성공 |
| Amazon CodeGuru Reviewer | `codeguru-reviewer` | — | `ListRepositoryAssociations` → 성공 |
| Amazon CodeGuru Security | `codeguru-security` | — | `ListScans` → 성공 |
| Amazon Cognito Identity | `cognito-identity` | 337 | — |
| Amazon Cognito Identity Provider | `cognito-idp` | 758 | — |
| Amazon Cognito Sync | `cognito-sync` | — | `ListIdentityPoolUsage` → 501 미구현 |
| Amazon Comprehend | `comprehend` | 67 | `ListDatasets` → 501 미구현 |
| Amazon Connect Cases | `connectcases` | 25 | `ListDomains` → 성공 |
| Amazon Connect Contact Lens | `connect-contact-lens` | 14 | — |
| Amazon Connect Customer Profiles | `customer-profiles` | 23 | `ListDomains` → 성공 |
| Amazon Connect Participant Service | `connectparticipant` | 17 | — |
| Amazon Connect Service | `connect` | 4 | `ListInstances` → 성공 |
| Amazon Connect Wisdom Service | `wisdom` | 49 | `ListAssistants` → 성공 |
| Amazon Data Lifecycle Manager | `dlm` | 23 | `GetLifecyclePolicies` → 성공 |
| Amazon DataZone | `datazone` | 26 | `ListDomains` → 성공 |
| Amazon Detective | `detective` | 39 | `ListGraphs` → 성공 |
| Amazon DevOps Guru | `devops-guru` | — | `ListMonitoredResources` → 성공 |
| Amazon DocumentDB Elastic Clusters | `docdb-elastic` | 38 | `ListClusterSnapshots` → 성공 |
| Amazon DocumentDB with MongoDB compatibility | `docdb` | 9 | `DescribeCertificates` → 성공 |
| Amazon DynamoDB | `dynamodb` | 1425 | `ListBackups` → 성공 |
| Amazon DynamoDB Accelerator (DAX) | `dax` | 24 | `DescribeClusters` → 성공 |
| Amazon DynamoDB Streams | `dynamodbstreams` | 16 | `ListStreams` → 성공 |
| Amazon EC2 Container Service | `ecs` | 683 | `ListAccountSettings` → 성공 |
| Amazon EKS Auth | `eks-auth` | 22 | — |
| Amazon Elastic Block Store | `ebs` | 29 | — |
| Amazon Elastic Compute Cloud | `ec2` | 1430 | `ListImagesInRecycleBin` → 501 미구현 |
| Amazon Elastic Container Registry | `ecr` | 363 | `ListPullTimeUpdateExclusions` → 성공 |
| Amazon Elastic Container Registry Public | `ecr-public` | 92 | `DescribeRegistries` → 성공 |
| Amazon Elastic File System | `efs` | 32 | `DescribeAccessPoints` → 성공 |
| Amazon Elastic Kubernetes Service | `eks` | 298 | `ListAccessPolicies` → 성공 |
| Amazon Elastic VMware Service | `evs` | 20 | `ListEnvironments` → 성공 |
| Amazon ElastiCache | `elasticache` | 159 | `ListAllowedNodeTypeModifications` → 400 `InvalidParameterCombination` |
| Amazon Elasticsearch Service | `es` | 9 | `ListDomainNames` → 성공 |
| Amazon EMR | `emr` | 240 | `ListClusters` → 성공 |
| Amazon EMR Containers | `emr-containers` | 24 | `ListJobTemplates` → 성공 |
| Amazon EventBridge | `events` | 840 | `ListApiDestinations` → 성공 |
| Amazon EventBridge Pipes | `pipes` | 171 | `ListPipes` → 성공 |
| Amazon EventBridge Scheduler | `scheduler` | 172 | `ListScheduleGroups` → 성공 |
| Amazon EventBridgeV2 | `eventbridgev2` | 42 | `ListEventBuses` → 성공 |
| Amazon Forecast Query Service | `forecastquery` | — | — |
| Amazon Forecast Service | `forecast` | — | `ListDatasetGroups` → 성공 |
| Amazon Fraud Detector | `frauddetector` | — | `ListEventPredictions` → 501 미구현 |
| Amazon FSx | `fsx` | 7 | `DescribeBackups` → 성공 |
| Amazon GameLift | `gamelift` | 41 | `ListAliases` → 성공 |
| Amazon GameLift Streams | `gameliftstreams` | 37 | `ListApplications` → 성공 |
| Amazon Glacier | `glacier` | — | — |
| Amazon GuardDuty | `guardduty` | 77 | `ListCustomDetectionRuleAssociations` → 성공 |
| Amazon HealthLake | `healthlake` | 24 | `ListDataTransformationJobs` → 성공 |
| Amazon Import/Export Snowball | `snowball` | — | `ListClusters` → 성공 |
| Amazon Inspector | `inspector` | — | `ListAssessmentRuns` → 501 미구현 |
| Amazon Interactive Video Service | `ivs` | 82 | `ListAdConfigurations` → 성공 |
| Amazon Interactive Video Service Chat | `ivschat` | 17 | `ListLoggingConfigurations` → 성공 |
| Amazon Interactive Video Service RealTime | `ivs-realtime` | 71 | `ListCompositions` → 성공 |
| Amazon Kendra Intelligent Ranking | `kendra-ranking` | — | `ListRescoreExecutionPlans` → 성공 |
| Amazon Keyspaces | `keyspaces` | 25 | `ListKeyspaces` → 성공 |
| Amazon Keyspaces Streams | `keyspacesstreams` | 20 | `ListStreams` → 성공 |
| Amazon Kinesis | `kinesis` | 319 | `ListChannels` → 성공 |
| Amazon Kinesis Analytics | `kinesisanalytics` | — | `ListApplications` → 성공 |
| Amazon Kinesis Analytics | `kinesisanalyticsv2` | 5 | `ListApplications` → 성공 |
| Amazon Kinesis Firehose | `firehose` | 268 | `ListDeliveryStreams` → 성공 |
| Amazon Kinesis Video Signaling Channels | `kinesis-video-signaling` | 15 | — |
| Amazon Kinesis Video Streams | `kinesisvideo` | 27 | `ListSignalingChannels` → 성공 |
| Amazon Kinesis Video Streams Archived Media | `kinesis-video-archived-media` | 20 | `ListFragments` → 400 `InvalidArgumentException` |
| Amazon Kinesis Video Streams Media | `kinesis-video-media` | 16 | — |
| Amazon Kinesis Video WebRTC Storage | `kinesis-video-webrtc-storage` | 19 | — |
| Amazon Lex Model Building Service | `lex-models` | — | `GetBots` → 성공 |
| Amazon Lex Model Building V2 | `lexv2-models` | 17 | `ListBots` → 성공 |
| Amazon Lex Runtime Service | `lex-runtime` | — | — |
| Amazon Lex Runtime V2 | `lexv2-runtime` | 14 | — |
| Amazon Lightsail | `lightsail` | 27 | `GetActiveNames` → 성공 |
| Amazon Location Service | `location` | 18 | `ListGeofenceCollections` → 성공 |
| Amazon Location Service Maps V2 | `geo-maps` | 24 | — |
| Amazon Location Service Places V2 | `geo-places` | 23 | — |
| Amazon Location Service Routes V2 | `geo-routes` | 62 | — |
| Amazon Lookout for Equipment | `lookoutequipment` | — | `ListDataIngestionJobs` → 501 미구현 |
| Amazon Machine Learning | `machinelearning` | — | `DescribeBatchPredictions` → 501 미구현 |
| Amazon Macie 2 | `macie2` | 22 | `ListAllowLists` → 501 미구현 |
| Amazon Managed Blockchain | `managedblockchain` | — | `ListAccessors` → 성공 |
| Amazon Managed Blockchain Query | `managedblockchain-query` | — | — |
| Amazon Managed Grafana | `grafana` | 19 | `ListVersions` → 성공 |
| Amazon Mechanical Turk | `mturk` | — | `ListBonusPayments` → 501 미구현 |
| Amazon MemoryDB | `memorydb` | 23 | `DescribeACLs` → 성공 |
| Amazon Neptune | `neptune` | 10 | `DescribeDBClusterEndpoints` → 501 미구현 |
| Amazon Neptune Graph | `neptune-graph` | 30 | `ListExportTasks` → 성공 |
| Amazon NeptuneData | `neptunedata` | — | `ListGremlinQueries` → 성공 |
| Amazon Omics | `omics` | 26 | `ListAnnotationImportJobs` → 501 미구현 |
| Amazon OpenSearch Ingestion | `osis` | 23 | `ListPipelineBlueprints` → 성공 |
| Amazon OpenSearch Service | `opensearch` | 320 | `ListApplications` → 성공 |
| Amazon Personalize | `personalize` | 6 | `ListBatchInferenceJobs` → 501 미구현 |
| Amazon Personalize Events | `personalize-events` | 19 | — |
| Amazon Personalize Runtime | `personalize-runtime` | 14 | `GetActionRecommendations` → 400 `InvalidInputException` |
| Amazon Pinpoint | `pinpoint` | 6 | `ListTemplates` → 501 미구현 |
| Amazon Pinpoint Email Service | `pinpoint-email` | — | `ListConfigurationSets` → 501 미구현 |
| Amazon Pinpoint SMS and Voice Service | `sms-voice` | 17 | `ListConfigurationSets` → 성공 |
| Amazon Pinpoint SMS Voice V2 | `pinpoint-sms-voice-v2` | 11 | `ListNotifyCountries` → 501 미구현 |
| Amazon Polly | `polly` | 54 | `ListLexicons` → 성공 |
| Amazon Prometheus Service | `amp` | 22 | `ListScrapers` → 성공 |
| Amazon Q Connect | `qconnect` | 30 | `ListAssistants` → 성공 |
| Amazon QuickSight | `quicksight` | 20 | `ListApprovalPolicies` → 501 미구현 |
| Amazon Recycle Bin | `rbin` | 21 | — |
| Amazon Redshift | `redshift` | 221 | `ListRecommendations` → 성공 |
| Amazon Rekognition | `rekognition` | 26 | `ListCollections` → 성공 |
| Amazon Relational Database Service | `rds` | 512 | `DescribeAccountAttributes` → 성공 |
| Amazon Route 53 | `route53` | 129 | `ListCidrCollections` → 성공 |
| Amazon Route 53 Domains | `route53domains` | 5 | `ListDomains` → 성공 |
| Amazon Route 53 Global Resolver | `route53globalresolver` | 5 | `ListAccessSources` → 501 미구현 |
| Amazon Route 53 Resolver | `route53resolver` | 149 | `ListFirewallConfigs` → 성공 |
| Amazon S3 Files | `s3files` | 28 | `ListFileSystems` → 성공 |
| Amazon S3 on Outposts | `s3outposts` | 13 | `ListEndpoints` → 성공 |
| Amazon S3 Tables | `s3tables` | 116 | `ListTableBuckets` → 성공 |
| Amazon S3 Vectors | `s3vectors` | 94 | `ListIndexes` → 400 `ValidationException` |
| Amazon Sagemaker Edge Manager | `sagemaker-edge` | — | — |
| Amazon SageMaker Feature Store Runtime | `sagemaker-featurestore-runtime` | 27 | — |
| Amazon SageMaker geospatial capabilities | `sagemaker-geospatial` | — | `ListEarthObservationJobs` → 성공 |
| Amazon SageMaker Metrics Service | `sagemaker-metrics` | 19 | — |
| Amazon SageMaker Runtime | `sagemaker-runtime` | 8 | — |
| Amazon SageMaker Runtime HTTP2 | — | — | — |
| Amazon SageMaker Service | `sagemaker` | 477 | `ListAIBenchmarkJobs` → 501 미구현 |
| Amazon Security Lake | `securitylake` | 3 | `ListDataLakeExceptions` → 404 `ResourceNotFoundException` |
| Amazon Simple Email Service | `ses` | 133 | `ListConfigurationSets` → 성공 |
| Amazon Simple Email Service | `sesv2` | 210 | `ListConfigurationSets` → 성공 |
| Amazon Simple Notification Service | `sns` | 533 | `ListOriginationNumbers` → 성공 |
| Amazon Simple Queue Service | `sqs` | 1418 | `ListQueues` → 성공 |
| Amazon Simple Storage Service | `s3` | 1677 | `ListBuckets` → 성공 |
| Amazon Simple Systems Manager (SSM) | `ssm` | 505 | `ListAssociations` → 성공 |
| Amazon Simple Workflow Service | `swf` | 70 | — |
| Amazon SimpleDB v2 | `simpledbv2` | 6 | `ListExports` → 성공 |
| Amazon Textract | `textract` | 26 | `ListAdapterVersions` → 성공 |
| Amazon Timestream Query | `timestream-query` | — | `ListScheduledQueries` → 500 `AmbiguousService` |
| Amazon Timestream Write | `timestream-write` | — | `ListBatchLoadTasks` → 500 `AmbiguousService` |
| Amazon Transcribe Service | `transcribe` | 28 | `ListCallAnalyticsCategories` → 성공 |
| Amazon Transcribe Streaming Service | — | 14 | — |
| Amazon Translate | `translate` | 23 | `ListLanguages` → 501 미구현 |
| Amazon Verified Permissions | `verifiedpermissions` | 29 | `ListPolicyStoreAliases` → 성공 |
| Amazon Voice ID | `voice-id` | — | `ListDomains` → 성공 |
| Amazon VPC Lattice | `vpc-lattice` | 21 | `ListDomainVerifications` → 501 미구현 |
| Amazon WorkDocs | `workdocs` | — | `DescribeActivities` → 501 미구현 |
| Amazon WorkMail | `workmail` | — | `ListOrganizations` → 501 미구현 |
| Amazon WorkMail Message Flow | `workmailmessageflow` | — | — |
| Amazon WorkSpaces | `workspaces` | 10 | `ListAccountLinks` → 성공 |
| Amazon Workspaces Instances | `workspaces-instances` | 25 | `ListInstanceTypes` → 성공 |
| Amazon WorkSpaces Thin Client | `workspaces-thin-client` | — | `ListDevices` → 501 미구현 |
| Amazon WorkSpaces Web | `workspaces-web` | — | `ListBrowserSettings` → 501 미구현 |
| AmazonApiGatewayManagementApi | `apigatewaymanagementapi` | 29 | — |
| AmazonApiGatewayV2 | `apigatewayv2` | 265 | `ListPortalProducts` → 성공 |
| AmazonConnectCampaignService | `connectcampaigns` | 62 | `ListCampaigns` → 성공 |
| AmazonConnectCampaignServiceV2 | `connectcampaignsv2` | 25 | `ListCampaigns` → 성공 |
| AmazonMQ | `mq` | 23 | `ListBrokers` → 성공 |
| AmazonMWAA | `mwaa` | 21 | `ListEnvironments` → 성공 |
| AmazonMWAAServerless | `mwaa-serverless` | 25 | `ListWorkflows` → 성공 |
| AmplifyBackend | `amplifybackend` | 15 | `ListS3Buckets` → 성공 |
| AppFabric | `appfabric` | 22 | `ListAppBundles` → 성공 |
| Application Auto Scaling | `application-autoscaling` | 150 | — |
| Application Migration Service | `mgn` | 21 | `ListApplications` → 400 `UninitializedAccountException` |
| ARC - Region switch | `arc-region-switch` | 22 | `ListPlans` → 성공 |
| Auto Scaling | `autoscaling` | 377 | `DescribeAccountLimits` → 성공 |
| AWS Account | `account` | 21 | `ListRegions` → 성공 |
| AWS AI Ops | `aiops` | 22 | `ListInvestigationGroups` → 성공 |
| AWS Amplify | `amplify` | 23 | `ListApps` → 성공 |
| AWS Amplify UI Builder | `amplifyuibuilder` | 23 | — |
| AWS App Mesh | `appmesh` | — | `ListMeshes` → 성공 |
| AWS App Runner | `apprunner` | — | `ListAutoScalingConfigurations` → 501 미구현 |
| AWS AppConfig Data | `appconfigdata` | 41 | — |
| AWS Application Cost Profiler | `applicationcostprofiler` | — | `ListReportDefinitions` → 성공 |
| AWS Application Discovery Service | `discovery` | — | `DescribeAgents` → 501 미구현 |
| AWS AppSync | `appsync` | 424 | `ListApis` → 성공 |
| AWS ARC - Zonal Shift | `arc-zonal-shift` | 26 | `ListAutoshifts` → 501 미구현 |
| AWS Artifact | `artifact` | 23 | `ListComplianceInquiries` → 성공 |
| AWS Audit Manager | `auditmanager` | — | `ListAssessmentReports` → 501 미구현 |
| AWS Auto Scaling Plans | `autoscaling-plans` | 10 | `DescribeScalingPlans` → 성공 |
| AWS B2B Data Interchange | `b2bi` | 44 | `ListCapabilities` → 성공 |
| AWS Backup | `backup` | 114 | `ListBackupAccessPoints` → 501 미구현 |
| AWS Backup Gateway | `backup-gateway` | 21 | `ListGateways` → 성공 |
| AWS Backup Search | `backupsearch` | 24 | `ListSearchJobs` → 성공 |
| AWS Batch | `batch` | 260 | `ListConsumableResources` → 성공 |
| AWS Billing | `billing` | 19 | `ListBillingViewSegments` → 501 미구현 |
| AWS Billing and Cost Management Dashboards | `bcm-dashboards` | 29 | `ListDashboards` → 성공 |
| AWS Billing and Cost Management Data Exports | `bcm-data-exports` | 21 | `ListExports` → 성공 |
| AWS Billing and Cost Management Pricing Calculator | `bcm-pricing-calculator` | 13 | `ListBillEstimates` → 501 미구현 |
| AWS Billing and Cost Management Recommended Actions | `bcm-recommended-actions` | 47 | `ListRecommendedActions` → 성공 |
| AWS Budgets | `budgets` | 28 | — |
| AWS Certificate Manager | `acm` | 266 | `ListAcmeEndpoints` → 성공 |
| AWS Certificate Manager Private Certificate Authority | `acm-pca` | 128 | `ListCertificateAuthorities` → 성공 |
| AWS Chatbot | `chatbot` | 44 | `ListCustomActions` → 성공 |
| AWS Clean Rooms ML | `cleanroomsml` | 8 | `ListAudienceExportJobs` → 501 미구현 |
| AWS Clean Rooms Service | `cleanrooms` | 24 | `ListCollaborations` → 성공 |
| AWS Cloud Control API | `cloudcontrol` | 176 | `ListResourceRequests` → 성공 |
| AWS Cloud Map | `servicediscovery` | 79 | `ListNamespaces` → 성공 |
| AWS Cloud9 | `cloud9` | — | `ListEnvironments` → 성공 |
| AWS CloudFormation | `cloudformation` | 1945 | `ListExports` → 성공 |
| AWS CloudHSM V2 | `cloudhsmv2` | 4 | `DescribeBackups` → 501 미구현 |
| AWS CloudTrail | `cloudtrail` | 147 | `ListChannels` → 성공 |
| AWS CloudTrail Data Service | `cloudtrail-data` | 19 | — |
| AWS CodeBuild | `codebuild` | 176 | `ListBuildBatches` → 성공 |
| AWS CodeCommit | `codecommit` | 152 | `ListApprovalRuleTemplates` → 성공 |
| AWS CodeConnections | `codeconnections` | 47 | `ListConnections` → 성공 |
| AWS CodeDeploy | `codedeploy` | 146 | `ListApplications` → 성공 |
| AWS CodePipeline | `codepipeline` | 200 | `ListActionTypes` → 성공 |
| AWS CodeStar connections | `codestar-connections` | 47 | `ListConnections` → 성공 |
| AWS CodeStar Notifications | `codestar-notifications` | 23 | `ListEventTypes` → 성공 |
| AWS Comprehend Medical | `comprehendmedical` | 21 | `ListEntitiesDetectionV2Jobs` → 성공 |
| AWS Compute Optimizer | `compute-optimizer` | 25 | `DescribeRecommendationExportJobs` → 403 `OptInRequiredException` |
| AWS Config | `config` | 166 | `ListConfigurationRecorders` → 성공 |
| AWS Continuum | `continuum` | — | `ListCollectors` → 501 미구현 |
| AWS Control Catalog | `controlcatalog` | 65 | `ListCommonControls` → 성공 |
| AWS Control Tower | `controltower` | 15 | `ListBaselines` → 성공 |
| AWS Cost and Usage Report Service | `cur` | 6 | `DescribeReportDefinitions` → 성공 |
| AWS Cost Explorer Service | `ce` | 5 | `ListCommitmentPurchaseAnalyses` → 501 미구현 |
| AWS Data Exchange | `dataexchange` | 27 | `ListDataGrants` → 성공 |
| AWS Data Pipeline | `datapipeline` | — | `ListPipelines` → 성공 |
| AWS Database Migration Service | `dms` | 3 | `ListTagsForResource` → 501 미구현 |
| AWS DataSync | `datasync` | 18 | `ListAgents` → 501 미구현 |
| AWS Device Farm | `devicefarm` | 8 | `ListDeviceInstances` → 501 미구현 |
| AWS DevOps Agent Service | `devops-agent` | 14 | `ListAgentSpaces` → 성공 |
| AWS Direct Connect | `directconnect` | 6 | `ListResiliencyGroups` → 501 미구현 |
| AWS Directory Service | `ds` | 149 | `ListADAssessments` → 성공 |
| AWS Directory Service Data | `ds-data` | 7 | — |
| AWS EC2 Instance Connect | `ec2-instance-connect` | 4 | — |
| AWS Elastic Beanstalk | `elasticbeanstalk` | 182 | `ListAvailableSolutionStacks` → 성공 |
| AWS Elemental Inference | `elementalinference` | 30 | `ListDictionaries` → 성공 |
| AWS Elemental MediaConvert | `mediaconvert` | 29 | `ListJobTemplates` → 성공 |
| AWS Elemental MediaLive | `medialive` | 29 | `ListChannels` → 성공 |
| AWS Elemental MediaPackage | `mediapackage` | 60 | `ListChannels` → 성공 |
| AWS Elemental MediaPackage v2 | `mediapackagev2` | 68 | `ListChannelGroups` → 성공 |
| AWS Elemental MediaPackage VOD | `mediapackage-vod` | 24 | `ListAssets` → 성공 |
| AWS Elemental MediaStore | `mediastore` | — | `ListContainers` → 성공 |
| AWS Elemental MediaStore Data Plane | `mediastore-data` | — | `ListItems` → 성공 |
| AWS End User Messaging | `endusermessaging` | 49 | `ListBrandProfiles` → 성공 |
| AWS End User Messaging Social | `socialmessaging` | 19 | `ListLinkedWhatsAppBusinessAccounts` → 성공 |
| AWS EntityResolution | `entityresolution` | 26 | `ListIdMappingWorkflows` → 성공 |
| AWS Fault Injection Simulator | `fis` | 54 | `ListActions` → 성공 |
| AWS Free Tier | `freetier` | 32 | `ListAccountActivities` → 성공 |
| AWS Global Accelerator | `globalaccelerator` | 12 | `ListAccelerators` → 성공 |
| AWS Glue | `glue` | 486 | `ListAssetTypes` → 501 미구현 |
| AWS Glue DataBrew | `databrew` | 10 | `ListDatasets` → 성공 |
| AWS Greengrass | `greengrass` | — | `ListBulkDeployments` → 501 미구현 |
| AWS Ground Station | `groundstation` | 24 | `ListConfigs` → 성공 |
| AWS Health APIs and Notifications | `health` | — | `DescribeAffectedEntitiesForOrganization` → 400 `SubscriptionRequiredException` |
| AWS Health Imaging | `medical-imaging` | 20 | `ListDatastores` → 성공 |
| AWS Identity and Access Management | `iam` | 785 | `ListAccessKeys` → 성공 |
| AWS Invoicing | `invoicing` | 21 | `ListInvoiceUnits` → 성공 |
| AWS IoT | `iot` | 277 | `ListActiveViolations` → 501 미구현 |
| AWS IoT Core Device Advisor | `iotdeviceadvisor` | 22 | `ListSuiteDefinitions` → 성공 |
| AWS IoT Data Plane | `iot-data` | 13 | `ListRetainedMessages` → 성공 |
| AWS IoT FleetWise | `iotfleetwise` | — | `ListCampaigns` → 501 미구현 |
| AWS IoT Greengrass V2 | `greengrassv2` | 70 | `ListComponents` → 성공 |
| AWS IoT Jobs Data Plane | `iot-jobs-data` | 9 | — |
| AWS IoT Secure Tunneling | `iotsecuretunneling` | 18 | `ListTunnels` → 성공 |
| AWS IoT SiteWise | `iotsitewise` | 64 | `ListAccessPolicies` → 성공 |
| AWS IoT Things Graph | `iotthingsgraph` | — | `DescribeNamespace` → 501 미구현 |
| AWS IoT TwinMaker | `iottwinmaker` | 25 | `ListWorkspaces` → 성공 |
| AWS IoT Wireless | `iotwireless` | 8 | `ListDestinations` → 501 미구현 |
| AWS Key Management Service | `kms` | 373 | `ListAliases` → 성공 |
| AWS Lake Formation | `lakeformation` | 10 | `ListDataCellsFilter` → 501 미구현 |
| AWS Lambda | `lambda` | 2470 | `ListCapacityProviders` → 성공 |
| AWS Lambda Core | `lambda-core` | 33 | `ListNetworkConnectors` → 성공 |
| AWS Launch Wizard | `launch-wizard` | 19 | `ListDeployments` → 성공 |
| AWS License Manager | `license-manager` | 7 | `ListDistributedGrants` → 501 미구현 |
| AWS License Manager Linux Subscriptions | `license-manager-linux-subscriptions` | 16 | `ListLinuxSubscriptionInstances` → 성공 |
| AWS License Manager User Subscriptions | `license-manager-user-subscriptions` | 18 | `ListIdentityProviders` → 성공 |
| AWS Marketplace Agreement Service | `marketplace-agreement` | 18 | `ListAgreementCharges` → 성공 |
| AWS Marketplace Catalog Service | `marketplace-catalog` | 25 | — |
| AWS Marketplace Commerce Analytics | `marketplacecommerceanalytics` | — | — |
| AWS Marketplace Deployment Service | `marketplace-deployment` | 6 | — |
| AWS Marketplace Discovery | `marketplace-discovery` | 78 | `ListPurchaseOptions` → 성공 |
| AWS Marketplace Entitlement Service | `marketplace-entitlement` | — | — |
| AWS Marketplace Reporting Service | `marketplace-reporting` | 17 | — |
| AWS MediaConnect | `mediaconnect` | 28 | `ListBridges` → 성공 |
| AWS MediaTailor | `mediatailor` | 15 | `ListChannels` → 501 미구현 |
| AWS Migration Hub | `mgh` | — | `ListApplicationStates` → 501 미구현 |
| AWS Migration Hub Config | `migrationhub-config` | — | `DescribeHomeRegionControls` → 성공 |
| AWS Migration Hub Orchestrator | `migrationhuborchestrator` | — | `ListPlugins` → 501 미구현 |
| AWS Migration Hub Refactor Spaces | `migration-hub-refactor-spaces` | — | `ListEnvironments` → 성공 |
| AWS Multi-party Approval | `mpa` | 19 | `ListApprovalTeams` → 성공 |
| AWS Network Firewall | `network-firewall` | 29 | `ListAnalysisReports` → 501 미구현 |
| AWS Network Manager | `networkmanager` | 27 | `ListAttachmentNatConfigurations` → 501 미구현 |
| AWS Network Security Manager Customer API | `network-security-manager` | 8 | `ListAdminAccounts` → 501 미구현 |
| AWS Organizations | `organizations` | — | `ListAWSServiceAccessForOrganization` → 501 미구현 |
| AWS Outposts | `outposts` | 27 | `ListCapacityTasks` → 성공 |
| AWS Parallel Computing Service | `pcs` | 13 | `ListClusters` → 성공 |
| AWS Performance Insights | `pi` | 21 | — |
| AWS Price List Service | `pricing` | 22 | `DescribeServices` → 성공 |
| AWS Proton | `proton` | — | `ListComponents` → 501 미구현 |
| AWS RDS DataService | `rds-data` | 42 | — |
| AWS re:Post Private | `repostspace` | — | `ListSpaces` → 성공 |
| AWS Resilience Hub | `resiliencehub` | 11 | `ListAppAssessments` → 성공 |
| AWS Resilience Hub V2 | `resiliencehubv2` | 41 | `ListDependencies` → 501 미구현 |
| AWS Resource Access Manager | `ram` | 14 | `ListPermissionAssociations` → 501 미구현 |
| AWS Resource Explorer | `resource-explorer-2` | 23 | `ListIndexes` → 성공 |
| AWS Resource Groups | `resource-groups` | 24 | `ListGroupResources` → 400 `BadRequestException` |
| AWS Resource Groups Tagging API | `resourcegroupstaggingapi` | 29 | `ListRequiredTags` → 501 미구현 |
| AWS Route53 Recovery Control Config | `route53-recovery-control-config` | 21 | `ListClusters` → 성공 |
| AWS Route53 Recovery Readiness | `route53-recovery-readiness` | — | `ListCells` → 성공 |
| AWS S3 Control | `s3control` | 44 | — |
| AWS Savings Plans | `savingsplans` | 21 | `DescribeSavingsPlans` → 성공 |
| AWS Secrets Manager | `secretsmanager` | 360 | `ListSecrets` → 성공 |
| AWS Security Agent | `securityagent` | 28 | `ListAgentSpaces` → 501 미구현 |
| AWS Security Token Service | `sts` | 215 | `GetCallerIdentity` → 성공 |
| AWS SecurityHub | `securityhub` | 24 | `ListAggregatorsV2` → 501 미구현 |
| AWS Service Catalog | `servicecatalog` | 15 | `ListAcceptedPortfolioShares` → 501 미구현 |
| AWS Service Catalog App Registry | `servicecatalog-appregistry` | — | `ListApplications` → 성공 |
| AWS Shield | `shield` | 18 | `ListAttacks` → 성공 |
| AWS Sign-In Service | `signin` | 19 | `ListResourcePermissionStatements` → 호출 실패 |
| AWS Signer | `signer` | 45 | `ListSigningJobs` → 성공 |
| AWS Signer Data Plane | `signer-data` | 1 | — |
| AWS Single Sign-On | `sso` | 16 | — |
| AWS Single Sign-On Admin | `sso-admin` | 25 | `ListApplicationProviders` → 성공 |
| AWS Snow Device Management | `snow-device-management` | — | `ListDevices` → 403 `AccessDeniedException` |
| AWS SSM-GUIConnect | `ssm-guiconnect` | 15 | `GetConnectionRecordingPreferences` → 404 `ResourceNotFoundException` |
| AWS SSO Identity Store | `identitystore` | 85 | `ListIdentityStores` → 501 미구현 |
| AWS SSO OIDC | `sso-oidc` | 19 | — |
| AWS Step Functions | `stepfunctions` | 858 | `ListActivities` → 성공 |
| AWS Storage Gateway | `storagegateway` | 1 | `ListAutomaticTapeCreationPolicies` → 501 미구현 |
| AWS Supply Chain | `supplychain` | 23 | `ListInstances` → 성공 |
| AWS Support | `support` | — | `DescribeCases` → 400 `SubscriptionRequiredException` |
| AWS Support App | `support-app` | 20 | `ListSlackChannelConfigurations` → 성공 |
| AWS Sustainability | `sustainability` | 32 | — |
| AWS Systems Manager for SAP | `ssm-sap` | 21 | `ListApplications` → 성공 |
| AWS Systems Manager Incident Manager | `ssm-incidents` | — | `ListIncidentRecords` → 성공 |
| AWS Systems Manager Incident Manager Contacts | `ssm-contacts` | — | `ListContacts` → 성공 |
| AWS Systems Manager QuickSetup | `ssm-quicksetup` | 23 | `ListConfigurationManagers` → 성공 |
| AWS Transfer Family | `transfer` | 112 | `ListCertificates` → 성공 |
| AWS User Experience Customization | `uxc` | 19 | `ListServices` → 성공 |
| AWS User Notifications | `notifications` | 26 | `ListManagedNotificationConfigurations` → 성공 |
| AWS User Notifications Contacts | `notificationscontacts` | 20 | `ListEmailContacts` → 성공 |
| AWS WAF | `waf` | — | `ListActivatedRulesInRuleGroup` → 501 미구현 |
| AWS WAF Regional | `waf-regional` | — | `ListActivatedRulesInRuleGroup` → 400 `WAFNonexistentItemException` |
| AWS WAFV2 | `wafv2` | 193 | `GetRuleGroup` → 400 `WAFInvalidParameterException` |
| AWS Well-Architected Tool | `wellarchitected` | 12 | `ListAgentProfiles` → 성공 |
| AWS Wickr Admin API | `wickr` | 8 | `ListNetworks` → 성공 |
| AWS X-Ray | `xray` | 161 | `ListResourcePolicies` → 501 미구현 |
| AWSBillingConductor | `billingconductor` | 18 | `ListAccountAssociations` → 403 `AccessDeniedException` |
| AWSDeadlineCloud | `deadline` | 27 | `ListAvailableMeteredProducts` → 501 미구현 |
| AWSKendraFrontendService | `kendra` | — | `ListIndices` → 성공 |
| AWSMainframeModernization | `m2` | — | `ListApplications` → 성공 |
| AWSMarketplace Metering | `meteringmarketplace` | — | — |
| AWSServerlessApplicationRepository | `serverlessrepo` | 16 | `ListApplications` → 성공 |
| Braket | `braket` | 18 | — |
| CloudWatch Observability Access Manager | `oam` | 25 | `ListLinks` → 성공 |
| CloudWatch Observability Admin Service | `observabilityadmin` | 20 | `ListCentralizationRulesForOrganization` → 성공 |
| CloudWatch Omni | `cloudwatchomni` | 37 | `ListAccessGrants` → 501 미구현 |
| CloudWatch RUM | `rum` | 81 | `ListAppMonitors` → 성공 |
| CodeArtifact | `codeartifact` | 98 | `ListDomains` → 성공 |
| Compute Optimizer Automation | `compute-optimizer-automation` | 20 | `ListAccounts` → 403 `OptInRequiredException` |
| Connect Health | `connecthealth` | 26 | `ListDomains` → 성공 |
| Cost Optimization Hub | `cost-optimization-hub` | 17 | `ListEnrollmentStatuses` → 성공 |
| Data Automation for Amazon Bedrock | `bedrock-data-automation` | 48 | `ListBlueprints` → 성공 |
| EC2 Image Builder | `imagebuilder` | 59 | `ListComponentBuildVersions` → 성공 |
| Elastic Disaster Recovery Service | `drs` | 15 | `ListRecoveryPlanExecutions` → 501 미구현 |
| Elastic Load Balancing | `elb` | 17 | `DescribeAccountLimits` → 501 미구현 |
| Elastic Load Balancing | `elbv2` | 516 | `DescribeAccountLimits` → 성공 |
| EMR Serverless | `emr-serverless` | 47 | `ListApplications` → 성공 |
| Firewall Management Service | `fms` | 23 | `ListAdminAccountsForOrganization` → 400 `AccessDeniedException` |
| IAM Roles Anywhere | `rolesanywhere` | 28 | `ListCrls` → 성공 |
| IAM Toolbox (Preview) | `iam-toolbox` | — | — |
| Inspector Scan | `inspector-scan` | 21 | — |
| Inspector2 | `inspector2` | 27 | `ListAccountPermissions` → 501 미구현 |
| Interconnect | `interconnect` | 15 | `ListConnections` → 성공 |
| Lambda MicroVMs | `lambda-microvms` | 44 | `ListManagedMicrovmImages` → 성공 |
| Lambda Web | `lambda-web` | 16 | `ListWebFunctions` → 성공 |
| MailManager | `mailmanager` | 11 | `ListAddonInstances` → 501 미구현 |
| Managed integrations for AWS IoT Device Management | `iot-managed-integrations` | 22 | `ListAccountAssociations` → 성공 |
| Managed Streaming for Kafka | `kafka` | 205 | `ListClusters` → 성공 |
| Managed Streaming for Kafka Connect | `kafkaconnect` | 20 | `ListConnectors` → 성공 |
| Migration Hub Strategy Recommendations | `migrationhubstrategy` | — | `ListAnalyzableServers` → 성공 |
| Network Flow Monitor | `networkflowmonitor` | 25 | `ListMonitors` → 성공 |
| Nova Act Service | `nova-act` | 22 | `ListWorkflowDefinitions` → 성공 |
| odb | `odb` | — | `ListAutonomousDatabaseCharacterSets` → 501 미구현 |
| OpenSearch Service Serverless | `opensearchserverless` | 77 | `ListCollectionGroups` → 성공 |
| Partner Central Account API | `partnercentral-account` | 16 | — |
| Partner Central Benefits API | `partnercentral-benefits` | 20 | — |
| Partner Central Channel API | `partnercentral-channel` | 20 | — |
| Partner Central Revenue Measurement API | `partnercentral-revenue-measurement` | — | — |
| Partner Central Selling API | `partnercentral-selling` | — | — |
| Payment Cryptography Control Plane | `payment-cryptography` | 23 | `ListAliases` → 성공 |
| Payment Cryptography Data Plane | `payment-cryptography-data` | 21 | — |
| PcaConnectorAd | `pca-connector-ad` | 15 | `ListConnectors` → 성공 |
| PricingPlanManager | `pricing-plan-manager` | 12 | `ListSubscriptions` → 성공 |
| Private CA Connector for SCEP | `pca-connector-scep` | 21 | `ListConnectors` → 성공 |
| QApps | `qapps` | — | — |
| QBusiness | `qbusiness` | — | `ListApplications` → 성공 |
| Redshift Data API Service | `redshift-data` | 25 | `ListDatabases` → 400 `ValidationException` |
| Redshift Serverless | `redshift-serverless` | 10 | `ListCustomDomainAssociations` → 501 미구현 |
| Route 53 Profiles | `route53profiles` | 19 | `ListProfileAssociations` → 성공 |
| Route53 Recovery Cluster | `route53-recovery-cluster` | 17 | `ListRoutingControls` → 성공 |
| RTBFabric | `rtbfabric` | 10 | `ListRequesterGateways` → 성공 |
| Runtime for Amazon Bedrock Data Automation | `bedrock-data-automation-runtime` | 16 | — |
| Sagemaker Job Runtime Service | `sagemakerjobruntime` | 14 | — |
| SageMaker Training Session Runtime | `sagemakertrainingsessionruntime` | 16 | — |
| Schemas | `schemas` | 30 | `ListDiscoverers` → 성공 |
| Security Incident Response | `security-ir` | — | `ListCases` → 성공 |
| Service Quotas | `service-quotas` | 40 | `ListRequestedServiceQuotaChangeHistory` → 성공 |
| SupportAuthZ | `supportauthz` | 2 | `ListSupportPermitRequests` → 501 미구현 |
| Synthetics | `synthetics` | 27 | `ListGroups` → 501 미구현 |
| Tax Settings | `taxsettings` | 15 | `ListSupplementalTaxRegistrations` → 성공 |
| Timestream InfluxDB | `timestream-influxdb` | 20 | `ListDbBackups` → 501 미구현 |
| TrustedAdvisor Public API | `trustedadvisor` | 20 | `ListChecks` → 403 `AccessDeniedException` |
