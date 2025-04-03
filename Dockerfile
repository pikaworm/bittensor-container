ARG TARGETARCH
ARG UBUNTU_VERSION="22.04"

FROM ubuntu:${UBUNTU_VERSION}

ARG PYTHON_VERSION="3.11"
ARG BITTENSOR_VERSION
ARG BITTENSOR_CLI_VERSION
ARG TARGETARCH

LABEL version="${BITTENSOR_VERSION}-${BITTENSOR_CLI_VERSION}"
LABEL maintainer="Pikaworm <pikaworm@hcm.partners>"

# Set non-interactive mode to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update \
    && apt-get install -y locales \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.UTF-8

RUN apt-get install -y curl git build-essential pkg-config libssl-dev python${PYTHON_VERSION}-minimal python${PYTHON_VERSION}-venv

# Install Rust & Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN python${PYTHON_VERSION} -m venv /root/.venv
ENV PIP_ROOT_USER_ACTION=ignore

# Install Bittensor
RUN apt-get install -y libsoup2.4-dev libjavascriptcoregtk-4.0-dev librust-pango-sys-dev libgdk3.0-cil-dev libgtk-3-dev libwebkit2gtk-4.0-dev

# Create a Conda environment and install dependencies
RUN /root/.venv/bin/pip install --upgrade bittensor==${BITTENSOR_VERSION} bittensor-cli==${BITTENSOR_CLI_VERSION}

# A custom tool for listing amount in RAO
RUN curl -fsSL https://raw.githubusercontent.com/opentensor/bittensor-delegates/main/public/delegates.json -o /usr/local/etc/delegates.json
COPY --chmod=755 utils/stake_list.py /usr/local/bin/stake_list.py

# Clean up
RUN /root/.venv/bin/pip cache purge
RUN apt clean all && rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.venv/bin:${PATH}"

# Use btcli from Conda environment
ENTRYPOINT ["btcli"]
