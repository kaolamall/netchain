# Build Geth in a stock Go builder container
FROM golang:1.10-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /go-blockchain
RUN cd /go-blockchain && make net

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-blockchain/build/bin/net /usr/local/bin/

EXPOSE 55555 8546 44444 44444/udp
ENTRYPOINT ["net"]
