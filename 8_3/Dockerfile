FROM golang:1.16 AS builder

# Copy the code from the host and compile it
# WORKDIR /build
WORKDIR $GOPATH/src/github.com/netology-code/sdvps-materials
COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix nocgo -o /app .

FROM alpine:3.22.1
RUN apk --no-cache add ca-certificates && \
    update-ca-certificates
COPY --from=builder /build/app /app
# CMD ["/app"]
ENTRYPOINT ["/app"]