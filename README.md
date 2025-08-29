# Docker pia-foss/manual-connections

Private Internet Access manual connections scripts but in a docker container.

## Getting Started

The upstream scripts are fairly user-friendly and will prompt for input, so a minimal command does not strictly require configuration.

```shell
docker run --rm -it unstoppablemango/pia-manual-connections:latest
```

In practice you'll want to supply at least `PIA_USER` and `PIA_PASS`.

```shell
docker run --rm -it \
  -e PIA_USER=p1234567 \
  -e PIA_PASS=your-strong-password \
  unstoppablemango/pia-manual-connections:latest
```

## Patches

This repo contains a few small patches to the upstream.
At the time of writing, these:

- [Stop the scripts from printing PIA_TOKEN](./patches/001-echo-token.patch)
- [Allow passing arguments to wireguard](./patches/002-wireguard-script-args.patch)

### Why not contribute upstream?

Mostly laziness, I'll get around to it eventually.

There hasn't been a [release in a while](https://github.com/pia-foss/manual-connections/releases/tag/v2.0.0) and there are a [number](https://github.com/pia-foss/manual-connections/pull/192) [of](https://github.com/pia-foss/manual-connections/pull/185) [year+ old](https://github.com/pia-foss/manual-connections/pull/189) [open](https://github.com/pia-foss/manual-connections/pull/91) [PRs](https://github.com/pia-foss/manual-connections/pull/64) with recent activity that have yet to be merged.
I'm not in much of a rush to contribute there.

## Docker

The `unstoppablemango/pia-manual-connections` docker image defined in [Dockerfile](./Dockerfile) zips up github.com/pia-foss/manual-connections into a neat little container for easy consumption.
Within the container, the repository is located at `/src` with the entrypoint defined as [/src/entrypoint.sh](./entrypoint.sh). The entrypoint sources [/src/run_setup.sh](https://github.com/pia-foss/manual-connections/blob/master/run_setup.sh) from the upstream.
A minimal set of configuration variables required to run the script can be found [in the source repository](https://github.com/pia-foss/manual-connections/#automated-setup).

By default, the scripts will persist data such as the auth token and serverlist in `/opt/piavpn-manual`.
You can mount a volume at this directory to interact with the script output.

### Configuration

For the most up-to-date configuration, refer to the [upstream repository](https://github.com/pia-foss/manual-connections/#automated-setup).
