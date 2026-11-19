# --- Stage 1: Builder ---
FROM golang:1.27-alpine AS builder

WORKDIR /src

# Cache dependency downloads separately from source changes
COPY go.mod go.sum ./
RUN go mod download

COPY cmd/ ./cmd/
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -ldflags="-s -w" -o /out/go-api ./cmd/api

# --- Stage 2: Minimal Non-Root Runtime ---
FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /out/go-api /go-api

EXPOSE 8080
USER nonroot:nonroot
ENTRYPOINT ["/go-api"]
