#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

setup() {
  export BUILDKITE_PLUGIN_SKAFFOLD_COMMAND="build"
  export BUILDKITE_PLUGIN_SKAFFOLD_INSTALL="false"
}

teardown() {
  unset BUILDKITE_PLUGIN_SKAFFOLD_COMMAND
  unset BUILDKITE_PLUGIN_SKAFFOLD_INSTALL
}

@test "Run command without command set" {

  unset BUILDKITE_PLUGIN_SKAFFOLD_COMMAND

  run $PWD/hooks/command

  assert_failure
  assert_output --partial "required property command is not set"

}

@test "Run unsupported skaffold command" {

  export BUILDKITE_PLUGIN_SKAFFOLD_COMMAND="fail"

  export HOME=/tmp

  run $PWD/hooks/command

  assert_failure
  assert_output --partial "unsupported command provided: fail"

}

@test "Run command to build" {

  export BUILDKITE_PLUGIN_SKAFFOLD_DEBUG="true"

  export HOME=/tmp

    stub skaffold \
      "build : echo skaffold build"
    stub buildkite-agent \
      "artifact upload : echo buildkite-agent artifact upload"
    stub cat \
      "skaffold-images.json : echo skaffold build images here"

  run $PWD/hooks/command

  assert_success

}

@test "Run command to deploy" {

  export BUILDKITE_PLUGIN_SKAFFOLD_DEBUG="true"
  export BUILDKITE_PLUGIN_SKAFFOLD_COMMAND="deploy"
  export BUILDKITE_PLUGIN_SKAFFOLD_PROFILE="test"

  export HOME=/tmp

    stub buildkite-agent \
      "artifact download : echo buildkite-agent artifact download"
    stub skaffold \
      "deploy : echo skaffold deploy"
    stub cat \
      "skaffold-images.json : echo skaffold build images here"

  run $PWD/hooks/command

  assert_success

}
