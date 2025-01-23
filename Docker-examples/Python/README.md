# Python 버전 도커 파일

## 필요 사항
- zsh/ 디렉토리 (zshrc, p10k.zsh 설정 파일들)
- requirements.txt (비어있어도 됨)
- Dockerfile
- docker-compose.yml

## 디렉토리 구조
```
project/
├── zsh/
│   ├── zshrc
│   └── p10k.zsh
├── src/           # 코드 저장 (삭제하지 마세요)
├── data/          # 데이터 저장 (삭제하지 마세요)
├── runs/          # 결과물 저장 (삭제하지 마세요)
├── Dockerfile
├── docker-compose.yml
└── requirements.txt
```

## 실행 방법

1. 첫 실행 또는 Dockerfile 변경 시:
```bash
docker compose up --build dev  # dev 서비스만 빌드 및 실행
```

docker-compose.yml 의 모든 서비스를 빌드하려면:
```bash
docker compose up --build
```

2. 일반 실행:
```bash
docker compose up dev
```

3. 이미 빌드된 상태에서 백그라운드 실행:
```bash
docker compose up -d dev
```

4. 컨테이너 접속 (새 터미널에서):
```bash
# 방법 1: docker compose 사용 (서비스 이름으로 쉽게 접근)
docker compose exec dev zsh
```

또는 `docker ps` 명령어로 컨테이너 이름을 확인하고, `docker exec` 명령어로 접속할 수 있습니다:

```bash
# 도커 컨테이너 이름 확인
docker ps
```

컨테이너 이름 또는 ID를 확인 후, 아래 명령어로 접속:

```bash
# 방법 2: docker 직접 사용 (컨테이너 이름/ID 필요)
docker exec -it [container_name] zsh
```

참고로 docker-compose.yml 에 정의된 컨테이너 이름은 `python-dev` 입니다.
수정을 원할 경우 `docker-compose.yml` 파일의 `container_name`을 수정하세요.
만약 삭제하면 자동으로 생성됩니다.

5. 컨테이너 종료:
```bash
docker compose down
```

6. 로그 보기 (별도 터미널 필요시):
```bash
docker compose logs -f dev
```

7. 컨테이너 재시작:
```bash
docker compose restart dev
```

## 주의사항
- data/, runs/, src/ 디렉토리는 볼륨으로 마운트되어 컨테이너가 삭제되어도 데이터가 보존됩니다.
- requirements.txt에 필요한 패키지를 추가하면 이미지 재빌드가 필요합니다.
- Dockerfile이나 requirements.txt 변경 시 `docker compose up --build dev`로 재빌드가 필요합니다.
- docker compose up --build는 `docker-compose.yml` 의 모든 서비스를 빌드하므로, 특정 서비스만 빌드하려면 서비스 이름을 지정해야 합니다. (예: dev)
- uv 로 설치한 패키지를 보려면 `uv pip list` 명령어를 사용하세요.(저는 몰라서 꽤 헤맸습니다.)