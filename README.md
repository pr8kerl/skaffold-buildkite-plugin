# Skaffold Buildkite Plugin

Allows your buildkite pipeline step to run [skaffold](https://skaffold.dev).
Only build and deploy commands are supported at the moment. Build image info is uploaded as an artifact.

## How?

* update your buildkite pipeline step to use the plugin

```yml
steps:
  - label: ":kubernetes: skaffold build"
    plugins:
      pr8kerl/skaffold#master:
        command: build
        install: true
        version: v1.13.1
        profile: dev
```
