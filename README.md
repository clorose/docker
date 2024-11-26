# Docker 겉핥기

- 컨테이너(가상화된 환경)를 사용하여 애플리케이션을 쉽게 실행하고 배포하는데 사용되는 오픈소스 플랫폼
- 개발부터 배포까지 동일한 환경을 보장해주는 것이 가장 큰 장점
- "한 번 만들면 어디서든 실행된다" (Build once, run anywhere)

아래는 제가 사용해본 내용을 정리한 것입니다.
실제 이 환경의 사용 예시는 [START.md](./START.md)에 있습니다.

## 도커 환경 구축

## 1. 설치
- [도커 데스크톱](https://www.docker.com/products/docker-desktop/) 다운로드 및 설치
- 설치 확인:
```bash
# 버전 확인
docker -v

# 설치 테스트
docker run hello-world
```

## 2. 이미지 관리
- 이미지란 컨테이너를 생성하기 위한 템플릿
- 애플리케이션을 실행하는데 필요한 모든 것을 포함(OS, 런타임, 라이브러리 등)
- DockerHub에서 이미지를 다운로드 받거나 직접 만들 수 있음

```bash
# 이미지 다운로드
# docker pull [이미지명]:[태그]
docker pull ubuntu:latest

# 이미지 이름 변경
docker tag ubuntu:latest ubuntu:my-tag

# 이미지 목록 확인
docker images 

# 이미지 삭제
docker rmi ubuntu:latest
```

## 3. 컨테이너 생성과 관리
- 컨테이너는 이미지를 실행한 상태
- 각 컨테이너는 독립적인 환경을 제공

```bash
# 기본 실행
docker run ubuntu:latest

# 주요 옵션
docker run -d ubuntu:latest  # 백그라운드 실행
docker run --name my-ubuntu ubuntu:latest  # 이름 지정
docker run -p 8080:80 nginx:latest  # 포트 매핑(호스트:컨테이너)

# 볼륨 마운트 (현재 디렉토리를 컨테이너의 /app에 마운트)
# Windows PowerShell: ${pwd}
# Windows CMD: %cd%
# Linux/Mac: $(pwd) 또는 ${PWD}
docker run -v ${pwd}:/app ubuntu:latest

# 컨테이너 관리
docker ps  # 실행 중인 컨테이너 목록
docker ps -a  # 모든 컨테이너 목록
docker start my-ubuntu  # 컨테이너 시작
docker stop my-ubuntu  # 컨테이너 중지
docker rm my-ubuntu  # 컨테이너 삭제
docker exec -it my-ubuntu bash  # 실행 중인 컨테이너에 접속
```

## 4. 개발 환경과 배포 환경 구성

### 개발 환경
개발 중에는 코드를 실시간으로 수정하고 확인해야 하므로, 볼륨 마운트를 사용합니다:

```bash
# Node.js 개발 환경 예시 (소스 코드 실시간 반영)
docker run -d \
  -v ${pwd}:/app \  # 현재 디렉토리를 컨테이너의 /app에 마운트
  -v /app/node_modules \  # node_modules는 컨테이너 내부 것 사용
  -p 3000:3000 \
  --name my-node \
  node:latest
```

더 복잡한 개발 환경은 docker-compose를 사용합니다:
```yaml
# docker-compose.yml
version: '3'
services:
  web:
    image: node:latest
    volumes:
      - .:/app  # 소스코드 공유
      - /app/node_modules  # 컨테이너의 node_modules 사용
    ports:
      - "3000:3000"
```

### 배포 환경
배포할 때는 코드가 포함된 독립적인 이미지가 필요합니다. Dockerfile을 사용하여 만듭니다:

```dockerfile
# Dockerfile
FROM node:latest

WORKDIR /app

# 프로젝트 파일을 컨테이너에 복사
COPY . .

# 패키지 설치 및 빌드
RUN npm install
RUN npm run build  # 필요한 경우

EXPOSE 3000
CMD ["npm", "start"]
```

```bash
# 이미지 빌드
docker build -t my-app:1.0 .

# 배포용 컨테이너 실행
docker run -d -p 3000:3000 my-app:1.0
```

## 5. 실제 사용 사례

### 웹 서버 실행
```bash
# nginx 웹 서버 실행
docker run -d -p 80:80 --name my-nginx nginx:latest
# 브라우저에서 http://localhost 접속하여 확인
```

## 6. Docker Compose
- 여러 컨테이너를 함께 실행할 때 사용
- 웹 애플리케이션 + 데이터베이스 구성 예시:

```yaml
version: '3'
services:
  web:
    build: .  # 현재 디렉토리의 Dockerfile 사용
    ports:
      - "3000:3000"
    volumes:
      - .:/app  # 소스 코드 실시간 반영
    depends_on:
      - db
    environment:
      - DATABASE_URL=postgres://user:pass@db:5432/dbname
  
  db:
    image: postgres:latest
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
      - POSTGRES_DB=dbname
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  postgres-data:  # 데이터 영구 저장
```

기본 명령어:
```bash
docker-compose up -d  # 백그라운드에서 실행
docker-compose down  # 중지 및 삭제
docker-compose ps  # 상태 확인
```

## 정리
- 도커는 개발과 배포를 일관되게 만들어주는 강력한 도구
- 개발 시에는 볼륨 마운트로 실시간 코드 반영
- 배포 시에는 Dockerfile로 독립적인 이미지 생성
- 여러 컨테이너는 Docker Compose로 관리

## 참고
간단한 사용법만 소개했으며, 추가 명령어(조금씩 추가 예정)은 [명령어](./command.md)에서 확인할 수 있습니다.
더 자세한 내용은 [도커 공식 문서](https://docs.docker.com/)를 참고하세요.