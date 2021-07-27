#!/usr/bin/env bats

# currently it is required to specify this fixed path to KUBECONFIG
export KUBECONFIG=/home/candidate/.kube/config

@test "Verification test - Verify if web deployment has 3 replicas" {
  run bash -c "kubectl get deploy web -ojsonpath='{.spec.replicas}'"
  [[ "$output" = "3" ]]
}

@test "Verification test - Verify if mysql chart has been deployed" {
  run bash -c "helm status db -ojson|jq -r '.info.status'"
  [[ "$status" -eq 0 ]]
  [[ "$output" = "deployed" ]]
}