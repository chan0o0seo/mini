from kubernetes import client, config
import time

# Kubernetes 설정 로드
config.load_incluster_config()

# Kubernetes API 클라이언트 생성
api = client.CoreV1Api()

# Kaniko Pod 정의 (YAML 파일 내용과 동일)
kaniko_pod = client.V1Pod(
    metadata=client.V1ObjectMeta(name=f"kaniko-{BUILD_NUMBER}", namespace="chanyoung"),
    spec=client.V1PodSpec(
        service_account_name="kaniko-sa",
        containers=[
            client.V1Container(
                name="kaniko",
                image="gcr.io/kaniko-project/executor:latest",
                args=[
                    "--dockerfile=/workspace/Dockerfile",
                    "--context=dir:///workspace",
                    f"--destination=cksdudtj/back:{BUILD_NUMBER}",
                ],
                volume_mounts=[
                    client.V1VolumeMount(name="docker-config", mount_path="/kaniko/.docker"),
                    client.V1VolumeMount(name="workspace", mount_path="/workspace"),
                ],
            )
        ],
        volumes=[
            client.V1Volume(
                name="docker-config",
                secret=client.V1SecretVolumeSource(secret_name="regcred"),
            ),
            client.V1Volume(
                name="workspace",
                persistent_volume_claim=client.V1PersistentVolumeClaimVolumeSource(
                    claim_name="jenkins-workspace"
                ),
            ),
        ],
    ),
)

# Kaniko Pod 생성
api.create_namespaced_pod(namespace="chanyoung", body=kaniko_pod)

# Kaniko Pod 종료 대기
while True:
    pod = api.read_namespaced_pod(name=f"kaniko-{BUILD_NUMBER}", namespace="chanyoung")
    if pod.status.phase == "Succeeded" or pod.status.phase == "Failed":
        break
    time.sleep(1)

# Kaniko Pod 종료 코드 확인
if pod.status.phase == "Succeeded":
    print("Kaniko Pod 정상 종료")
    # 다음 작업 수행 (예: 배포)
    # ...
else:
    print("Kaniko Pod 비정상 종료")
    # 오류 처리
    exit(1)