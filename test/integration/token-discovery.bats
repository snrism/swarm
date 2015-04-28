#!/usr/bin/env bats

load helpers

# Generate a random token
function create_token() {
	TOKEN=$(curl -X POST https://discovery-stage.hub.docker.com/v1/clusters)
}

function teardown() {
	swarm_join_cleanup
	swarm_manage_cleanup
	stop_docker
}

@test "token discovery" {
	start_docker 2
	create_token
	swarm_manage token://${TOKEN}
	swarm_join   token://${TOKEN}

	run docker_swarm info
	[[ "${lines[3]}" == *"Nodes: 2"* ]]
}
