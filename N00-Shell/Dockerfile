FROM alpine:latest
RUN apk update && apk add openssh-server
EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
