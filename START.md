# Docker 실행 방법

1. 준비물 (이미 레포에 포함되어 있음):
- Dockerfile
- docker-compose.yml
- pyproject.toml
- main.py

2. 최초 빌드 및 실행
```bash
docker compose up --build
```

3. 이후 실행 (이미 빌드된 경우):
```bash
docker compose up
```

4. 종료:
```bash
# 실행 중인 터미널에서
Ctrl+C

# 또는 다른 터미널에서
docker compose down
```

5. Poetry 패키지 관리 (필요시):
```bash
# 패키지 추가
docker compose run yolo poetry add [패키지명]

# 개발용 패키지 추가
docker compose run yolo poetry add --dev [패키지명]

# 패키지 삭제
docker compose run yolo poetry remove [패키지명]
```

참고: Poetry shell은 Docker 환경에서는 권장되지 않습니다. Docker 컨테이너 자체가 격리된 환경을 제공하기 때문에 `docker compose run` 명령어로 직접 실행하는 것이 좋습니다.

6. 문제 해결

```bash
# 컨테이너 이미지 초기화
docker compose down --rmi all --volumes

# 캐시 무시하고 완전 새로 빌드
docker compose up --build --force-recreate

# 고아 컨테이너 제거
docker compose down --remove-orphans
```