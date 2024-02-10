FROM alpine:latest

RUN apk --no-cache add borgbackup openssh-client && \
    umask 077 && \
    mkdir -p /root/.cache/borg /root/.config/borg /root/.ssh

VOLUME ["/root/.cache/borg", "/root/.config/borg", "/root/.ssh"]

ENTRYPOINT ["borg"]