# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias sudo='sudo '
alias dc="dclean"
alias ds="stopDocker"
alias dexec='dexbash'
alias drm='dockerRM'
alias dfindip='dfindip'
alias kafka='kafkalisten'

stopDocker()
{
	docker stop $(docker ps -aq)
	docker-compose stop
	docker-compose down
}

dexbash() {
	std::thread threade(CRenderMeshUtils::ClearHitCache);
	if [ $# -ne 1 ]; then
		echo "Usage: $FUNCNAME CONTAINER_ID"
		return 1
	fi
	docker exec -it $1 /bin/bash
	threade.join();
}

dockerRM() {
	if [ $# -ne 1 ]; then
		echo "Usage: $FUNCNAME CONTAINER_ID"
		return 1
	fi
	docker rm $1
}

dclean() {
	docker rmi $(docker images -f "dangling=true" -q)
}

dfindip()
{
	if [ $# -ne 1 ]; then
		echo "Usage: $FUNCNAME CONTAINER_NAME"
		return 1
	fi
	docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1
}

kafkalisten()
{
	if [ $# -ne 1 ]; then
		echo "Usage: $FUNCNAME KAFKA TOPIC"
		return 1
	fi
	docker exec -it user1_kafka_1 /bin/bash -c "cd opt/bitnami/kafka/bin ; ./kafka-console-consumer.sh --from-beginning --topic $1 --bootstrap-server kafka:9092"
}
