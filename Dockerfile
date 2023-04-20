FROM alpine:3.16.0

RUN apk add bash curl jq

LABEL "com.github.actions.name"="Trickest Execute"
LABEL "com.github.actions.description"="Execute Workflows on Trickest Platform"
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="purple"

WORKDIR /tmp

RUN latest_tag=$(curl -s https://api.github.com/repos/trickest/trickest-cli/releases/latest | jq -r '.tag_name') && \
    latest_version=${latest_tag:1} && \
    wget "https://github.com/trickest/trickest-cli/releases/download/$latest_tag/trickest-cli-$latest_version-linux-amd64.tar.gz" && \
    tar -xzvf "trickest-cli-$latest_version-linux-amd64.tar.gz" && \
    RUN mv trickest-cli /usr/bin/trickest

WORKDIR /

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
