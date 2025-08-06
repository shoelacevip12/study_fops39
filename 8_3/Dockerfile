FROM golang:1.16 AS builder


WORKDIR /app
COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix nocgo -o /app/hello .

FROM alpine:3.22.1
RUN apk --no-cache add ca-certificates && \
    update-ca-certificates

COPY --from=builder /app/hello /app
ENTRYPOINT ["/app"]