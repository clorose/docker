# Docker & Docker Compose 명령어 총정리

## **1. Docker 명령어**

### **1.1 컨테이너 관리**

| **기능**                    | **명령어**                      | **설명**                            |
| --------------------------- | ------------------------------- | ----------------------------------- |
| **실행 중인 컨테이너 확인** | `docker ps`                     | 현재 실행 중인 컨테이너 목록 확인   |
| **모든 컨테이너 확인**      | `docker ps -a`                  | 중지된 컨테이너 포함 전체 목록 확인 |
| **컨테이너 시작**           | `docker start <container_name>` | 중지된 컨테이너를 시작              |
| **컨테이너 중지**           | `docker stop <container_name>`  | 실행 중인 컨테이너를 중지           |
| **컨테이너 삭제**           | `docker rm <container_name>`    | 중지된 컨테이너를 삭제              |
| **컨테이너 로그 확인**      | `docker logs <container_name>`  | 특정 컨테이너의 로그를 확인         |

---

### **1.2 이미지 관리**

| **기능**             | **명령어**                       | **설명**                          |
| -------------------- | -------------------------------- | --------------------------------- |
| **이미지 목록 확인** | `docker images`                  | 다운로드된 이미지 목록 확인       |
| **이미지 삭제**      | `docker rmi <image_name>`        | 특정 이미지를 삭제                |
| **이미지 빌드**      | `docker build -t <image_name> .` | Dockerfile을 기반으로 이미지 빌드 |
| **이미지 가져오기**  | `docker pull <image_name>`       | Docker Hub에서 이미지 다운로드    |

---

### **1.3 네트워크 관리**

| **기능**               | **명령어**                     | **설명**                  |
| ---------------------- | ------------------------------ | ------------------------- |
| **네트워크 목록 확인** | `docker network ls`            | 생성된 네트워크 목록 확인 |
| **새 네트워크 생성**   | `docker network create <name>` | 사용자 정의 네트워크 생성 |
| **네트워크 삭제**      | `docker network rm <name>`     | 특정 네트워크 삭제        |

---

### **1.4 볼륨 관리**

| **기능**           | **명령어**                    | **설명**              |
| ------------------ | ----------------------------- | --------------------- |
| **볼륨 목록 확인** | `docker volume ls`            | 생성된 볼륨 목록 확인 |
| **새 볼륨 생성**   | `docker volume create <name>` | 새 볼륨 생성          |
| **볼륨 삭제**      | `docker volume rm <name>`     | 특정 볼륨 삭제        |

---

## **2. Docker Compose 명령어**

### **2.1 기본 명령어**

| **기능**                      | **명령어**                           | **설명**                          |
| ----------------------------- | ------------------------------------ | --------------------------------- |
| **컨테이너 실행**             | `docker compose up`                  | 모든 서비스를 실행 (로그 표시)    |
| **백그라운드 실행**           | `docker compose up -d`               | 모든 서비스를 백그라운드에서 실행 |
| **서비스 빌드 및 실행**       | `docker compose up --build`          | 변경된 Dockerfile로 빌드 후 실행  |
| **특정 서비스 실행**          | `docker compose up <서비스>`         | 특정 서비스만 실행                |
| **특정 서비스 빌드 및 실행**  | `docker compose up --build <서비스>` | 특정 서비스만 빌드 후 실행        |
| **컨테이너 및 네트워크 정리** | `docker compose down`                | 모든 서비스 종료 및 네트워크 삭제 |
| **서비스 로그 확인**          | `docker compose logs`                | 모든 서비스의 로그 출력           |
| **특정 서비스 로그 확인**     | `docker compose logs <서비스>`       | 특정 서비스의 로그 출력           |
| **서비스 상태 확인**          | `docker compose ps`                  | 실행 중인 서비스 상태 확인        |

---

### **2.2 개발 환경에서의 사용**

#### 주요 패턴
1. **로그 확인하며 실행**
   ```bash
   docker compose up
   ```
   - 모든 서비스 실행 및 실시간 로그 출력.

2. **특정 서비스만 실행**
   ```bash
   docker compose up backend
   ```
   - `backend` 서비스만 실행.

3. **코드 변경 시 이미지 재빌드 후 실행**
   ```bash
   docker compose up --build
   ```

4. **특정 서비스 재빌드 후 실행**
   ```bash
   docker compose up --build frontend
   ```

---

### **2.3 프로덕션 환경에서의 사용**

#### 주요 패턴
1. **백그라운드에서 실행**
   ```bash
   docker compose up -d
   ```

2. **이미지 빌드 후 백그라운드 실행**
   ```bash
   docker compose up -d --build
   ```

3. **서비스 상태 확인**
   ```bash
   docker compose ps
   ```

4. **서비스 중지 및 네트워크 정리**
   ```bash
   docker compose down
   ```

---

### **2.4 CI/CD 파이프라인에서의 사용**

#### 주요 패턴
1. **브랜치 또는 환경별 실행**
   ```bash
   docker compose up --build staging
   docker compose up --build production
   ```

2. **테스트용 서비스만 실행**
   ```bash
   docker compose up test
   ```

3. **테스트 완료 후 종료 및 정리**
   ```bash
   docker compose down
   ```

---

## **3. 실습 예제**

```bash
# 실행 중인 컨테이너 확인
docker ps

# 모든 서비스 빌드 및 실행
docker compose up --build

# 특정 서비스 빌드 및 실행
docker compose up frontend

# 서비스 로그 확인
docker compose logs
```

### **2.5 컨테이너 내부 접근**

| **기능**               | **명령어**                               | **설명**                           |
| ---------------------- | ---------------------------------------- | ---------------------------------- |
| **단일 명령 실행**     | `docker exec <container_name> <command>` | 컨테이너 내부에서 단일 명령을 실행 |
| **인터랙티브 쉘 실행** | `docker exec -it <container_name> bash`  | 컨테이너 내부에 bash 쉘로 접근     |
| **zsh 쉘 실행**        | `docker exec -it <container_name> zsh`   | 컨테이너 내부에 zsh 쉘로 접근      |
| **환경 변수 확인**     | `docker exec -it <container_name> env`   | 컨테이너 내부의 환경 변수를 확인   |

---

#### **예제**

1. **단일 명령 실행**:
   ```bash
   docker exec my_app ls /app
   ```
   - `my_app` 컨테이너 내부의 `/app` 디렉토리 파일 목록 확인.

2. **bash 쉘로 접근**:
   ```bash
   docker exec -it my_app bash
   ```
   - 컨테이너 내부에서 bash 쉘 실행 후 작업 가능.

3. **zsh 쉘로 접근**:
   ```bash
   docker exec -it my_app zsh
   ```

4. **환경 변수 확인**:
   ```bash
   docker exec -it my_app env
   ```