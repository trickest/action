FROM alpine:3.16.0

RUN apk add bash unzip

LABEL "com.github.actions.name"="Trickest Execute"
LABEL "com.github.actions.description"="Execute Workflows on Trickest Platform"
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="purple"

WORKDIR /tmp

RUN wget https://github.com/trickest/trickest-cli/releases/download/v1.0.3/trickest-cli-1.0.3-linux-amd64.zip

# Unzip
RUN unzip trickest-cli-1.0.3-linux-amd64.zip

RUN mv trickest-cli-1.0.3-linux-amd64 trickest

# Make binary executable
RUN chmod +x trickest

# Move binary to path
RUN mv trickest /usr/bin/trickest

WORKDIR /

COPY entrypoint.sh .

ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]