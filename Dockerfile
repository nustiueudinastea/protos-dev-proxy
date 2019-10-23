FROM golang:1.13.3 as builder
LABEL protos="0.0.1" \
      protos.installer.metadata.description="This applications provides a proxy for doing Protos application development" \
      protos.installer.metadata.capabilities="ResourceProvider,ResourceConsumer,InternetAccess,GetInformation,PublicDNS,AuthUser" \
      protos.installer.metadata.requires="dns" \
      protos.installer.metadata.provides="mail" \
      protos.installer.metadata.publicports="9999/tcp" \
      protos.installer.metadata.name="protosproxy"

ADD . "/go/src/protosproxy/"
WORKDIR "/go/src/protosproxy/"
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build protosproxy.go
CMD go run protosproxy.go

FROM alpine:latest
LABEL protos="0.0.1" \
      protos.installer.metadata.description="This applications provides a proxy for doing Protos application development" \
      protos.installer.metadata.capabilities="ResourceProvider,ResourceConsumer,InternetAccess,GetInformation,PublicDNS,AuthUser" \
      protos.installer.metadata.requires="dns" \
      protos.installer.metadata.provides="mail" \
      protos.installer.metadata.publicports="9999/tcp" \
      protos.installer.metadata.name="protosproxy"

RUN apk add ca-certificates
COPY --from=builder /go/src/protosproxy/protosproxy /usr/bin/protosproxy
RUN chmod +x /usr/bin/protosproxy
ENTRYPOINT ["/usr/bin/protosproxy"]
