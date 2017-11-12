# Cloud9 Dockerfile

This repository contains Dockerfile of Cloud9 IDE

## Features

- Custom container workspace directory by ```C9_WORKSPACE``` var (make it easier to link with VOLUME_FROM other container, not just host directory mapping).

## Installation

1. Install [Docker](https://www.docker.com/).

## Usage

    git clone https://github.com/gustavw/cloud9.git && cd cloud9
    
    docker network create --subnet=172.20.0.0/16 rnld0  
    
    sudo docker build --force-rm=true --tag="$USER/cloud9-docker:latest" .
      
    docker run --net rnld0 -it --ip=172.20.0.10 \
        -e C9_EXTRA=--collab \
        -v ~/cloud9/keys/:/root/.ssh/ \
        -d $USER/cloud9-docker
    
*You don't need to create a new network or mount ssh keys from host machine however this is convinient for me*
    
*Workspace directory at `/cloud9/workspace`*

## Extra params

By ```C9_EXTRA``` it is possible define extra params to cloud9

    --readonly          Run in read only mode
    --auth              Basic Auth username:password
    --collab            Whether to enable collab.

example:

    C9_EXTRA=--collab -a username:password

