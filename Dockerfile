# start with Alpine distro
FROM alpine:3.3

MAINTAINER Adam Eilers <adam.eilers@gmail.com>

# set build args for USER_NAME and USER_PASS, defaults provided below
# NOTE: add additional ARG variables here (defaults optional)
#   - more info at:
#       - https://docs.docker.com/engine/reference/builder/#arg
#       - https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables-build-arg
#   - example: ARG NODE_VER="4.2.4"
ARG IMAGE_TYPE="production"

ARG USER_NAME="docker"
ARG USER_PASS="docker"

ARG NODE_VER="4.2.4"

# set environment variables
# NOTE: add additional ENV variables here
#   - more info at:
#       - https://docs.docker.com/engine/reference/builder/#env
#   - example: PATH=${PATH}:/opt/node/bin
ENV HOME_DIR="/home/${USER_NAME}" \
    WORK_DIR="workspace" \
    NODE_DIR="/opt/node" \
    PATH=${PATH}:/opt/node/bin

# copy install scripts to image
COPY ./script/envInstall.sh ./script/projectInstall.sh /script/

# update, upgrade, and install bash and invoke environment install script
# NOTE: bash is just a personal preference here... (5MB penalty)
RUN apk update && apk upgrade -U -a \
    && apk add bash-completion \
    && bash /script/envInstall.sh ${IMAGE_TYPE}

# change to ${WORK_DIR} and run project install script as ${USER_NAME} here
WORKDIR ${HOME_DIR}/${WORK_DIR}
USER ${USER_NAME}
RUN bash /script/projectInstall.sh ${IMAGE_TYPE}

# expose SSH port by default
# NOTE: change port 3000 below to match node app port
EXPOSE 3000 22

# NOTE: change CMD to be command to start node app
#   - example: ["node", "./bin/server"]
CMD ["/bin/bash"]
