#!/bin/sh

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
fi

set -o errexit
set -o nounset
set -o pipefail

eval "$(ssh-agent)"

# check if keyfile is given
if [ -e "${KEY_FILE:?}" ]; then
	echo "found keyfile"
	cp "$KEY_FILE" "$KEY_TARGET"
	chown -v root:root "$KEY_TARGET"
	./root/ssh-add.sh "$KEY_TARGET" "$KEY_PASSPHRASE"
else
	echo "no keyfile found"
fi

# write known_hosts
if [ -n "${KNOWN_HOSTS}" ]; then
	echo "$KNOWN_HOSTS" > "$KNOWN_HOSTS_FILE"
fi

# start what user wants
exec "$@"