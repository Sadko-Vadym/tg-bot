# Build stage
FROM golang:1.21-alpine AS builder

ARG VERSION=v1.0.0
ARG GIT_COMMIT=unknown

WORKDIR /build

# Copy go mod files
COPY go.mod go.sum* ./
RUN go mod download

# Copy source code
COPY . .

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags "-X github.com/sadko/tg-bot/cmd.appVersion=${VERSION}" \
    -o kbot \
    main.go

# Runtime stage
FROM alpine:latest

RUN apk --no-cache add ca-certificates tzdata

WORKDIR /app

# Copy binary from builder
COPY --from=builder /build/kbot .

# Create non-root user
RUN addgroup -g 1000 kbot && \
    adduser -D -u 1000 -G kbot kbot && \
    chown -R kbot:kbot /app

USER kbot

EXPOSE 8080

ENTRYPOINT ["./kbot"]

