# BUILD
FROM golang:latest AS build

RUN apt-get update && apt-get install -y xz-utils && rm -rf /var/lib/apt/lists/*

WORKDIR /src

COPY ./go.mod ./go.sum ./

# Download dependencies
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
     go mod download -x

# Import the code from the context.
COPY ./ ./

RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    GOARCH=amd64 GOOS=linux CGO_ENABLED=0  go build -o /fin cmd/fin/main.go

# PACKAGE
FROM alpine:latest

RUN apk add --update --no-cache ca-certificates git curl bash jq && rm -rf /var/cache/apk/*

COPY --from=build /fin /usr/bin/fin

EXPOSE 80

ENTRYPOINT ["/usr/bin/fin"]
