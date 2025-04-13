# Docker pia-foss/manual-connections

Private Internet Access manual connections scripts but in a docker container.

## Getting Started

Simply run:

```shell
docker run --rm -it unstoppablemango/pia-manual-connections:latest
```

## Docker

The `unstoppablemango/pia-manual-connections` docker image defined in [Dockerfile](./Dockerfile) zips up github.com/pia-foss/manual-connections into a neat little container for easy consumption.
The repository is located at `/src` with the entrypoint defined as [entrypoint.sh](./entrypoint.sh), which sources [/src/run_setup.sh](https://github.com/pia-foss/manual-connections/blob/master/run_setup.sh).
A minimal set of configuration variables required to run the script can be found [here](https://github.com/pia-foss/manual-connections/#automated-setup).

By default, the scripts will persist data such as the auth token and serverlist in `/opt/piavpn-manual`.
You can mount a volume at this directory to interact with the script output.

### Configuration

The supported environment variables are defined [over here](https://github.com/pia-foss/manual-connections/#automated-setup).
