FROM python:3.12-slim-bookworm

LABEL project="OpenTelemetry Demo"
LABEL service="recommendation"
LABEL description="Recommendation Service"

WORKDIR   /usr/src/app

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

RUN opentelemetry-bootstrap -a install

RUN useradd --create-home appuser &&\
    chown -R appuser:appuser /usr/src/app

USER appuser

ENV RECOMMENDATION_PORT=1010

EXPOSE 1010

ENTRYPOINT [ "python", "recommendation_server.py" ]