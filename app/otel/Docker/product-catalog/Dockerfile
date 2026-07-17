FROM golang:1.22-alpine AS builder

LABEL project="Ultimate DevOps Project"
LABEL application="OpenTelemetry Demo"
LABEL service="product-catalog"

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download 

COPY . .

RUN go build -o product-catalog ./

FROM alpine:3.20

WORKDIR /app

COPY --from=builder /app/product-catalog .
COPY --from=builder /app/products ./products

EXPOSE 8088

ENV  PRODUCT_CATALOG_PORT=8088

ENTRYPOINT [ "./product-catalog" ]


