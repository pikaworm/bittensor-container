# Container for Bittensor Toolkits

## Docker

### Install Docker

Docker can be installed with the guidance from here: https://docs.docker.com/engine/install/.

For users with macOS on Apple Silicon, use the guidance here: https://docs.docker.com/desktop/setup/install/mac-install/.

## Build the Container Image

* For ARM64 machines, such as Apple Silicon.

`docker build -t btcli .`

## Run

For running `btcli` from inside the container with the current Bittensor configuration, you need to map your personal directory `~/.bittensor` to `/root/.bittensor` inside the container.

`docker run -v ~/.bittensor:/root/.bittensor --rm btcli wallet list`
