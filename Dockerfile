FROM golang:alpine AS builder
COPY . /app
WORKDIR /app
RUN  apk upgrade && apk add git npm && \
npm install && npm run package && \
CGO_ENABLED=0 go build -ldflags "-s -w -X github.com/axllent/mailpit/config.Version=dev" -o /mailpit

FROM alpine:latest
COPY --from=builder /mailpit /mailpit
LABEL maintainer="Hariprasath Ravichandran <udthariprasath@gmail.com>"
ARG VERSION=unknown
# Check if the VERSION argument has been provided
RUN if [ "$VERSION" = "unknown" ]; then \
      echo "ERROR: Missing mandatory build argument VERSION"; \
      exit 1; \
    fi
RUN apk upgrade --no-cache && apk add --no-cache tzdata

EXPOSE 1025/tcp 1110/tcp 8025/tcp

HEALTHCHECK --interval=15s --start-period=10s --start-interval=1s CMD ["/mailpit", "readyz"]

ENTRYPOINT ["/mailpit"]
