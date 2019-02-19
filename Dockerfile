FROM alpine:3.9

ENV KNOWN_HOSTS="" \
	KEY_FILE="/root/key" \
	KEY_TARGET="/root/.ssh/id_rsa" \
	KNOWN_HOSTS_FILE="/root/.ssh/known_hosts" \
	KEY_PASSPHRASE=""

COPY ["entrypoint.sh", "ssh-add.sh", "/root/"]

RUN apk update && \
# rsync openssh-client ca-certificates for secure rsync
# expect for using ssh key
	apk add --no-cache openssh-client rsync ca-certificates expect && \
	\
	mkdir "/root/.ssh/" && \
	chmod u=rx,go= "/root/entrypoint.sh" "/root/ssh-add.sh" "/root/.ssh/" && \
	\
	rm -rf /var/cache/apk/*
	
ENTRYPOINT ["/root/entrypoint.sh"]

CMD ["rsync", "--help"]