# start with Alpine (NodeJS) Production image
FROM aeilers/alpine-nodejs-base:4.4.2-prod

MAINTAINER Adam Eilers <adam.eilers@gmail.com>

# set environment variables
ENV HOME_DIR="/home/${USER_NAME}" \
    WORK_DIR="workspace"

# copy install scripts to image
COPY ./script/* /opt/script/

# change to ${WORK_DIR} and run project install script as ${USER_NAME}
WORKDIR ${HOME_DIR}/${WORK_DIR}
USER ${USER_NAME}
RUN bash /opt/script/projectInstall.sh ${IMAGE_TYPE}

# expose standard NodeJS port of 3000
# NOTE: change port 3000 below to match node app port
EXPOSE 3000

# NOTE: change CMD to be command to start node app
#   - example: ["node", "./bin/server"]
CMD ["/bin/bash"]
