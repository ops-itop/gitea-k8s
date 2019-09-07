FROM alpine:3.10
RUN apk add --no-cache git curl sudo openssh-keygen bash busybox-suid coreutils file
RUN curl -s -L https://github.com/go-gitea/gitea/releases/download/v1.9.2/gitea-1.9.2-linux-amd64 -o /gitea
RUN curl -s -L https://github.com/aptible/supercronic/releases/download/v0.1.9/supercronic-linux-amd64 -o /supercronic
RUN chmod +x /gitea
RUN chmod +x /supercronic
RUN adduser -D git
RUN echo "git ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/git
USER git
ADD run.sh /
ADD dump.sh /
ENTRYPOINT ["/bin/sh", "/run.sh"]

