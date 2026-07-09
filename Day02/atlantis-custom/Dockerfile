FROM ghcr.io/runatlantis/atlantis:latest

COPY repos.yaml /etc/atlantis/repos.yaml

ENTRYPOINT ["atlantis"]

CMD ["server", "--repo-config=/etc/atlantis/repos.yaml"]