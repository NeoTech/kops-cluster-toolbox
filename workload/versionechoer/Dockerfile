# Builder image
FROM       golang:1.13-alpine3.10 as builder

ARG        VERSION

WORKDIR    /go/src/app/

# Note go.sum is empty at this time as we have no non stdlib package deps at this time
COPY       go.mod go.sum ./
RUN        go mod download

COPY       *.go  ./
RUN        CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o versionechoer -ldflags "-X main.version=${VERSION}" .


# Final image - Will use alpine rather than scratch so we can troubleshoot
FROM       alpine:3.10

COPY       --from=builder /go/src/app/versionechoer /usr/local/bin

EXPOSE     5000
# nobody:nobody, will use ids so k8s deployments can match
USER       65534:65534

ENTRYPOINT ["/usr/local/bin/versionechoer"]
