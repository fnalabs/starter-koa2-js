# start with Alpine Linux Base image
FROM aeilers/alpine-base:2.0.0-alpha
MAINTAINER Adam Eilers <adam.eilers@gmail.com>

ARG APP_PATH="/home/root/workspace/"

# set environment variables
ENV NODE_ENV="production" \
    NODE_PATH="/opt/node" \
    PATH=${PATH}:/opt/node/bin \
    PORT=3000

# copy install scripts to image
COPY ./script/*Install.sh /opt/script/

# copy NodeJS and Project code
# NOTE: build process must output gzip of required application files
ADD node.tar.gz ${NODE_PATH}
ADD project.tar.gz ${APP_PATH}

# change to workspace and run project install script
WORKDIR ${APP_PATH}
RUN bash /opt/script/projectInstall.sh

# expose standard NodeJS port of 3000
# NOTE: change port 3000 below to match node app port
EXPOSE 3000

# NOTE: change CMD to be command to start node app
#   - example: ["node", "./bin/server"]
CMD ["/bin/bash"]
