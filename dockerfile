FROM --platform=$TARGETPLATFORM python:3.12-slim

# 시스템 패키지 설치
RUN apt-get update && apt-get install -y \
  build-essential \
  libgl1-mesa-glx \
  libglib2.0-0 \
  libpng-dev \
  libjpeg-dev \
  curl \
  && rm -rf /var/lib/apt/lists/*

# Poetry 설치 및 설정
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/opt/poetry/bin:$PATH"

WORKDIR /app

# 의존성 설치
COPY pyproject.toml poetry.lock* ./
RUN poetry install --no-dev \
  && poetry env list \
  && poetry env info

# 가상환경 PATH 추가
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONPATH="/app:$PYTHONPATH"

# 볼륨 마운트 디렉토리 준비
RUN mkdir -p /app/data /app/runs \
  && chmod 777 /app/data /app/runs

CMD ["poetry", "run", "python", "main.py"]