#!/bin/bash
#Checks every container if it has a given label, if so every volume of container is backuped
#+ Every ContainerName which is given as argument is backuped

set -o errexit
set -o nounset
set -o pipefail

readonly backupLabel="backup"
readonly backupContainers=("$@")
	
# all containers which aren't "CREATED" only (CREATED will hang)
# shellcheck disable=SC2207
readonly allContainers=($(docker ps -a --format '{{.Names}}' --filter "status=restarting" --filter "status=running" --filter "status=removing" --filter "status=paused" --filter "status=exited" --filter "status=dead" | sort))


for container in "${allContainers[@]}"
	do
	backupPlan=$(docker inspect --format '{{index .Config.Labels "$backupLabel"}}' "$container")
	
	# check if label existing
	if [ -n "$backupPlan" ]; then
		if [ "$backupPlan" = "volumes" ]; then
			echo -e "\e[32m[INFO]\e[0mContainer >$container< has Label for volume backup"
			backupContainerVolumes "$container"
		else
			echo -e "\e[33m[WARN]\e[0mContainer >$container< has Label for backup, but can't parse its value, fallback to volume backup"
			backupContainerVolumes "$container"
		fi
		
	# if container is marked for backup
	elif printf '%s\n' "${backupContainers[@]}" | grep -q -P "^${container}$"; then
		echo -e "\e[32m[INFO]\e[0mContainer >$container< is marked for backup"
		backupContainerVolumes "$container"
	
	# if container is NOT marked for backup
	else
		echo -e "\e[33m[WARN]\e[0mContainer >$container< isn't marked for backup"
	fi
done