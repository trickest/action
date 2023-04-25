FROM --platform=linux/amd64 golang:1.19-alpine as build

RUN go install github.com/trickest/trickest-cli@latest


FROM alpine:3.16.0

RUN apk add bash curl jq

LABEL "com.github.actions.name"="Trickest Execute"
LABEL "com.github.actions.description"="Execute Workflows on Trickest Platform"
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="purple"

COPY --from=build /go/bin/trickest-cli /usr/bin/trickest

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
