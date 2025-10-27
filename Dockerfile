FROM ubuntu:jammy
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt/lists apt-get update
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt/lists apt-get install -y git build-essential


RUN git clone -b binsub-thing --recursive https://github.com/edmcman/angr-dev.git /angr-dev

WORKDIR /angr-dev

# pin repos
RUN git clone --recursive https://github.com/angr/archinfo.git
RUN cd archinfo && git reset --hard 6c428025b4304ab5b333bf6b4b676d7569d3eaca

RUN git clone --recursive https://github.com/angr/pyvex.git
RUN cd pyvex &&  git reset --hard f1563c5da904bd2608aebcd324a5dbb1b9263858

RUN git clone --recursive https://github.com/angr/claripy.git
RUN cd claripy && git reset --hard 7fdcf1834ba2343d0ef6a1227c4cb8d0a6104a5b

RUN git clone --recursive https://github.com/angr/ailment.git
RUN cd ailment && git reset --hard bdedcedb76fc989638488d7221d7bd87186ca15f

RUN git clone --recursive https://github.com/angr/angr-management.git
RUN cd angr-management && git reset --hard dbd91b4b0d53c063339bfb9a1a3410eaf5c90a1c

RUN git clone --recursive https://github.com/angr/binaries.git
RUN cd binaries && git reset --hard 7934528a00e9d46c8da36c98ef631581da8adf65

RUN git clone --recursive https://github.com/angr/archr.git
RUN cd archr && git reset --hard c4ae82f7bd77d768cf9b210602b2e2a54dc6aff1

COPY ./angr-type-inference /angr-dev/angr
COPY ./cle /angr-dev/cle

RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt/lists apt-get install -y python3-pip
RUN --mount=type=cache,target=/root/.cache/pip pip3 install virtualenv
RUN --mount=type=cache,target=/root/.cache/pip ./setup.sh -i -e angr

ENV PATH="/root/.virtualenvs/angr/bin/:$PATH"

RUN --mount=type=cache,target=/root/.cache/pip pip install pyrsistent hjson
RUN mkdir /wdir
WORKDIR /wdir
RUN --mount=type=cache,target=/root/.cache/pip pip install matplotlib

ENTRYPOINT ["python"]



