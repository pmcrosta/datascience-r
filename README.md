# datascience-r
Docker files for data science with R

This repo contains a Dockerfile for building a container with RStudio and some often-used packages. The container is based on the rocker/verse Docker container. Everything below assumes a docker client is installed locally.

# Building the image
Clone the repo and run the following in the directory to build the container:

`docker build -t datascience-r .`

# Adding to Google Container Registry


# Launching GCE instance with container



# Helpful commands

To build a container:
`docker build -t datascience-r .`

To list images:
`docker image ls -a`

To run the container:
`docker run -d -e ROOT=TRUE -p 8787:8787 datascience-r`

To list containers:
`docker container ls -a`

To ssh into a container with ID ac95e48eec75
`docker exec -it ac95e48eec75 /bin/bash`

To ssh into a version of the container as root:
`docker run --rm -ti datascience-r  bash`

To get a list of installed packages
`dpkg -l | less`
