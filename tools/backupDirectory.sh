#!/bin/sh
#This example is for HiDrive, it is using this
#Rsync over SSH
#The remote structure which will be created:
#HOST/container/*name of container*/*mount source*/*content*
#mount source
#Name of the volume or
#Escaped path for bind mount



#How to use?
#1. Check if Rsync protocol for HiDrive is activated
#2. Create env-file like below (without #)
#backupContainer.env-file contains:
#KEY_PASSPHRASE=...
#KNOWN_HOSTS=...(maybe connect once and lookup in ~/.ssh/known_hosts)
#3. Set host, env_file, private_key

set -o errexit
set -o nounset
set -o pipefail

readonly BACKUP_DIRECTORY="$1"
readonly HOST="userXYZ@rsync.hidrive.strato.com:/users/userXYZ" #the path which always exists, 
readonly ENV_FILE="$HOME/backupContainer.env-file"
readonly PRIVATE_KEY="$HOME/backupContainer.priv"

readonly ContainerName="backupContainer.sh"

#check whats needed
if [ -z "$BACKUP_DIRECTORY" ]; then
	echo "[error]invalid(empty) BACKUP_DIRECTORY"
fi
if [ -z "$HOST" ]; then
	echo "[error]invalid HOST"
fi
if [ -z "$ContainerName" ]; then
	echo "[error]invalid ContainerName"
fi
if [ -z "$ENV_FILE" ] || [ ! -e "$ENV_FILE" ]; then
	echo "[error]invalid ENV_FILE"
fi
if [ -z "$PRIVATE_KEY" ] || [ ! -e "$PRIVATE_KEY" ]; then
	echo "[error]invalid PRIVATE_KEY"
fi
echo "creating backup of Container: $BACKUP_DIRECTORY"

docker run -ti --rm --name "$ContainerName" \
	 --env-file="$ENV_FILE" \
	 -v "$PRIVATE_KEY:/root/key:ro" \
	 -v "$BACKUP_DIRECTORY:/home/data:ro" \
	 jusito/rsync-ssh \
	 rsync -altDv --delete -e 'ssh -i /root/.ssh/id_rsa' "/home/data/" "$HOST"
