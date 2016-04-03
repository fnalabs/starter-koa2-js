# docker-alpine-nodejs-boilerplate
Contains boilerplate Dockerfiles and supporting install scripts for a Development and Production [Alpine Linux](http://alpinelinux.org/) w/ [NodeJS](https://nodejs.org/en/) Docker image.
- Production variant (starting at ~47MB virtual size)
- Development variant (starting at ~249MB virtual size)

NOTE: final image sizes will increase based on project dependencies.

## Purpose
To provide a starting point for all of my NodeJS projects. There are separate Dockerfiles to build [Development]() and [Production]() images specific to the project. The install script is mostly automated and meant to be reused during Development to pick up the latest NodeJS dependency versions on a regular basis. The provided `USER_NAME` has fully permissions to the file and can re-run it with the following command:

```
$ ./opt/script/projectInstall.sh
```

I have also marked other areas in the scripts to add additional dependencies for the project not covered by default.

## Usage
The boilerplate code is meant to be fully functional if the defaults are required only. If not, copy the files into a project-specific repository and configure as necessary.
- Production image

  ```
  docker build \
    --build-arg USER_NAME="<user_name>" \
    --build-arg USER_PASS="<user_pass>" \
    --build-arg IMAGE_PROJECT="https://github.com/<user_name>/repo.git" \
    -t <user_name>/alpine-nodejs-project .
  ```

- Development image

  ```
  docker build \
    --build-arg USER_NAME="<user_name>" \
    --build-arg USER_PASS="<user_pass>" \
    --build-arg USER_SSH="$(cat ~/.ssh/id_rsa)" \
    --build-arg USER_SSH_PUB="$(cat ~/.ssh/id_rsa.pub)" \
    --build-arg IMAGE_PROJECT="git@github.com:<user_name>/repo.git" \
    --build-arg IMAGE_TYPE="dev" \
    -f Dockerfile.dev \
    -t <user_name>/alpine-nodejs-project .
  ```

Then, to run the images, use the following base commands. The Development container adds [privileged](https://docs.docker.com/engine/reference/commandline/run/#full-container-capabilities-privileged) access to the container along with a [volume mount](https://docs.docker.com/engine/reference/commandline/run/#mount-volume-v-read-only) for the project workspace.
- Production container

  ```
  docker run \
      --name <app_name> \
      -u <user_name> \
      -p <public_port>:<node_app_port> \
      -dt <user_name>/alpine-nodejs-project
  ```

- Development container

  ```
  docker run \
      --privileged \
      --name <app_name> \
      -u <user_name> \
      -v /home/<user_name>/workspace \
      -p <public_port>:<node_app_port> \
      -dt <user_name>/alpine-nodejs-project
  ```
