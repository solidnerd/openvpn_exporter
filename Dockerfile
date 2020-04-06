FROM golang:1.14-buster AS build-env

ENV GO111MODULE=on \
    CGO_ENABLED=0

WORKDIR /src/openvpn_exporter

COPY go.mod .
COPY go.sum .
RUN go mod download

# add source
COPY . .

RUN mkdir -p bin && go build -ldflags="-w -s" -o bin/openvpn_exporter

# final stage
FROM debian:buster-slim as final
COPY --from=build-env /src/openvpn_exporter/bin /bin/
ENTRYPOINT ["/bin/openvpn_exporter"]
CMD [ "-h" ]
