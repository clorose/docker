[🏠 홈으로](../README.md)

# Docker 이해하기

## 목차
- [Docker 이해하기](#docker-이해하기)
  - [목차](#목차)
  - [도커란 무엇인가](#도커란-무엇인가)
- [Chapter 1: 도커 기본 개념 이해하기](#chapter-1-도커-기본-개념-이해하기)
  - [1. 이미지](#1-이미지)
  - [2. 컨테이너](#2-컨테이너)
- [Chapter 2: 웹 개발 환경 구성하기](#chapter-2-웹-개발-환경-구성하기)
  - [1. Dockerfile](#1-dockerfile)
    - [개발 환경 vs 운영 환경](#개발-환경-vs-운영-환경)
      - [개발 환경 (Dockerfile.dev)](#개발-환경-dockerfiledev)
      - [운영 환경 (Dockerfile.prod)](#운영-환경-dockerfileprod)
    - [프로젝트 구조](#프로젝트-구조)
  - [2. Docker Compose](#2-docker-compose)
    - [환경별 실행 방법](#환경별-실행-방법)
    - [자주 사용하는 Docker Compose 명령어](#자주-사용하는-docker-compose-명령어)
- [Chapter 3: 유용한 도커 명령어](#chapter-3-유용한-도커-명령어)
  - [도커의 장점](#도커의-장점)

## 도커란 무엇인가
- 컨테이너(가상화된 환경)를 사용하여 애플리케이션을 쉽게 실행하고 배포하는데 사용되는 오픈소스 플랫폼
- "Build once, run anywhere" (한 번 만들면 어디서든 실행된다) 의 철학을 따름
- 개발부터 배포까지 동일한 환경을 보장해주는 것이 가장 큰 장점

# Chapter 1: 도커 기본 개념 이해하기

## 1. 이미지
- 컨테이너를 생성하기 위한 템플릿
- 애플리케이션을 실행하는데 필요한 모든 것을 포함
  - OS, 런타임, 라이브러리, 시스템 도구 등
- 읽기 전용(Read-Only)으로 불변성 보장
- DockerHub에서 이미지를 다운로드 받아서 사용

```bash
# 이미지 다운로드
docker pull ubuntu:latest

# 이미지 목록 확인
docker images

# 이미지 이름 변경
docker tag ubuntu:latest ubuntu:my-tag
```

## 2. 컨테이너
- 이미지를 실행한 상태
- 각각 독립된 실행 환경을 제공
- 호스트와 다른 컨테이너들로부터 격리됨
- 필요할 때 생성/시작/중지/삭제 가능

```bash
# 기본 실행 (우분투 예시)
docker run ubuntu:latest
# 참고: 기본 OS 이미지는 실행 후 바로 종료됩니다
# 대화형 모드로 실행하려면:
docker run -it ubuntu:latest

# 컨테이너 목록 확인
docker ps  # 실행 중인 컨테이너만
docker ps -a  # 중지된 컨테이너 포함

# 컨테이너 관리
docker start 컨테이너이름  # 시작
docker stop 컨테이너이름   # 중지
docker rm 컨테이너이름    # 삭제
```

# Chapter 2: 웹 개발 환경 구성하기

## 1. Dockerfile 
- 이미지를 만들기 위한 설정 파일
- 베이스 이미지, 복사할 파일, 실행할 명령어 등을 정의
- 프로젝트의 모든 의존성과 설정을 코드로 관리
- 일반적으로 각 서비스 디렉토리에 `Dockerfile` 위치

### 개발 환경 vs 운영 환경

#### 개발 환경 (Dockerfile.dev)
```dockerfile
FROM node:20-alpine
WORKDIR /app

COPY package.json ./
RUN npm install  # 모든 의존성 설치 (devDependencies 포함)

# 소스코드는 볼륨으로 마운트하므로 COPY 불필요
# 실시간 코드 반영을 위해 볼륨 사용

CMD ["npm", "run", "dev"]  # 개발 서버 실행
```
- 빠른 개발을 위한 설정
- 소스코드 실시간 반영(hot reload)
- 개발 도구 및 디버깅 도구 포함
- 개발 서버 사용

#### 운영 환경 (Dockerfile.prod)
```dockerfile
# 빌드 단계
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json ./
RUN npm ci --only=production  # 프로덕션 의존성만 설치
COPY . .
RUN npm run build

# 실행 단계
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["npm", "start"]  # 프로덕션 서버 실행
```
- 최적화된 빌드
- 불필요한 개발 도구 제외
- 다단계 빌드로 이미지 크기 최소화
- 보안 강화

### 프로젝트 구조
```
project/
├── frontend/
│   ├── Dockerfile.dev
│   ├── Dockerfile.prod
│   └── src/
├── backend/
│   ├── Dockerfile.dev
│   ├── Dockerfile.prod
│   └── src/
└── docker-compose.yml
```

## 2. Docker Compose
- 여러 컨테이너를 함께 정의하고 실행하기 위한 도구
- 개발환경에 필요한 모든 서비스를 하나의 파일로 관리
- 환경변수를 통해 개발/운영 설정 전환 가능

```yaml
version: '3'
services:
  frontend:
    build: 
      context: ./frontend
      dockerfile: Dockerfile.${NODE_ENV}  # 환경에 따라 Dockerfile 선택
    ports:
      - "3000:3000"
    volumes:
      - ./frontend:/app  # 개발환경에서만 필요
      - /app/node_modules
    environment:
      - NODE_ENV=${NODE_ENV:-development}
    
  backend:
    build: 
      context: ./backend
      dockerfile: Dockerfile.${NODE_ENV}
    ports:
      - "4000:4000"
    volumes:
      - ./backend:/app  # 개발환경에서만 필요
      - /app/node_modules
    environment:
      - NODE_ENV=${NODE_ENV:-development}
    depends_on:
      - db
    
  db:
    image: postgres:latest
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=secret
    volumes:
      - postgres-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  postgres-data:
```

### 환경별 실행 방법
```bash
# 개발 환경 실행
NODE_ENV=development docker compose up --build

# 운영 환경 실행
NODE_ENV=production docker compose up --build
```

### 자주 사용하는 Docker Compose 명령어
```bash
# 모든 서비스 실행
docker compose up

# 특정 서비스만 실행
docker compose up frontend

# 서비스 로그 확인
docker compose logs -f backend

# 서비스 중지 및 컨테이너 제거
docker compose down
```

> 예시 코드는 `docker-examples/` 디렉토리를 참고하세요.

# Chapter 3: 유용한 도커 명령어
```bash
# 포트 매핑
docker run -p 8080:80 nginx

# 환경 변수 설정
docker run -e DATABASE_URL=postgres://localhost:5432 backend

# 볼륨 마운트
docker run -v $(pwd):/app frontend
```

각 환경에 따라 설정이 달라질 수 있으므로, 필요한 옵션을 찾아서 사용하세요.
- [도커 환경별 설정](../Docker-examples/README.md)

## 도커의 장점
1. **일관성**: 개발, 테스트, 운영 환경이 동일
2. **격리성**: 각 컨테이너는 독립적으로 실행
3. **이식성**: 어떤 환경에서도 동일하게 실행
4. **확장성**: 필요에 따라 컨테이너를 쉽게 추가/제거


[🔝 맨 위로](#docker-이해하기) | [🏠 홈으로](../README.md)