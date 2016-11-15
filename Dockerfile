# start with Alpine Linux Base image
# NOTE: change FROM statement to preferred Node.js image
FROM aeilers/alpine-nodejs-base:latest-lts
MAINTAINER Adam Eilers <adam.eilers@gmail.com>

# NOTE: if user created, change APP_PATH to user's workspace
ARG APP_PATH="/home/root/workspace/"
ARG APP_SOURCE="."
ARG PORT

# set environment variables
ENV NODE_ENV="${IMAGE_TYPE:-production}" \
    PORT="${PORT:-3000}"

# copy install scripts to image
COPY ./script/*Install.sh /opt/script/

# copy Node.js and Project code
# NOTE: APP_SOURCE can use build process compressed output for smaller production builds
ADD ${APP_SOURCE} ${APP_PATH}

# change to workspace and run project install script
WORKDIR ${APP_PATH}
RUN bash /opt/script/projectInstall.sh

# expose standard Node.js port of 3000
EXPOSE 3000 22

# NOTE: change CMD to be command to start node app
# e.g. ["node", "./bin/server"]
CMD ["/bin/bash"]
