# start with Alpine Linux Base image
# NOTE: change FROM statement to preferred Node.js image
FROM aeilers/alpine-nodejs-base:latest-lts
MAINTAINER Adam Eilers <adam.eilers@gmail.com>

ARG APP_PATH="/home/root/workspace/"
ARG PORT="3000"

# set environment variables
ENV NODE_ENV="${IMAGE_TYPE:-production}" \
    PORT="${PORT:-3000}"

# copy install scripts to image
COPY ./script/*Install.sh /opt/script/

# copy NodeJS and Project code
# NOTE: build process must output gzip of required application files
ADD project.tar.gz ${APP_PATH}

# change to workspace and run project install script
WORKDIR ${APP_PATH}
RUN bash /opt/script/projectInstall.sh

# expose standard NodeJS port of 3000
EXPOSE 3000 22

# NOTE: change CMD to be command to start node app
#   - example: ["node", "./bin/server"]
CMD ["/bin/bash"]
