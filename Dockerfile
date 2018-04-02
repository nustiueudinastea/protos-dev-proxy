FROM golang:1.8.3
LABEL protos="0.0.1" \
      protos.installer.metadata.description="This applications provides a proxy for doing Protos application development" \
      protos.installer.metadata.capabilities="ResourceProvider,ResourceConsumer,InternetAccess,GetInformation,PublicDNS,AuthUser" \
      protos.installer.metadata.requires="dns" \
      protos.installer.metadata.provides="certificate" \
      protos.installer.metadata.name="protosproxy"
ADD . "/go/src/protosproxy/"
WORKDIR "/go/src/protosproxy/"
#RUN go get github.com/jpillora/go-tcp-proxy/cmd/tcp-proxy
RUN go get github.com/nustiueudinastea/protoslib-go
CMD go run protosproxy.go
