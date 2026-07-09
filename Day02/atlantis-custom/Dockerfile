FROM ghcr.io/runatlantis/atlantis:latest

USER root

RUN apk add --no-cache \
    aws-cli \
    jq \
    curl

RUN VERSION=$(curl -s https://api.github.com/repos/open-policy-agent/conftest/releases/latest | jq -r .tag_name) && \
    curl -L -o /tmp/conftest.tar.gz \
    https://github.com/open-policy-agent/conftest/releases/download/${VERSION}/conftest_${VERSION#v}_Linux_x86_64.tar.gz && \
    tar -xzf /tmp/conftest.tar.gz -C /tmp && \
    mv /tmp/conftest /usr/local/bin/conftest && \
    chmod +x /usr/local/bin/conftest

COPY repos.yaml /etc/atlantis/repos.yaml

USER atlantis

ENTRYPOINT ["atlantis"]

CMD ["server", "--repo-config=/etc/atlantis/repos.yaml"]