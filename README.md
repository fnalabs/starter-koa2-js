# docker-alpine-nodejs-boilerplate

Contains boilerplate Dockerfiles and supporting install scripts for all stages of code in a [Alpine Linux](http://alpinelinux.org/) w/ [Node.js](https://nodejs.org/en/) Docker image. (starting at ~21MB compressed)(starting at ~56MB virtual size)

NOTE: final image sizes will increase based on project dependencies.

## Purpose

To provide a starting point for Node.js projects. There is a single Dockerfile with build args that allows you do build a specific image for each stage of code. The install script is mostly automated and meant to be reused during Development to pick up the latest Node.js dependency versions on a regular basis. The provided `USER_NAME` has full permissions to the file and can re-run it with the following command:

```
$ ./opt/script/projectInstall.sh
```

I have also marked other areas in the scripts to add additional dependencies for the project not covered by default.

## Usage

The boilerplate code is meant to be fully functional if only the defaults are required. If not, copy the files into a project-specific repository and configure as necessary.

- Development
  - uses `docker-compose` to create local development containers.
    - `docker-compose build` to build the development image.
    - `docker-compose up` to (re)create/start the development container.
    - `docker-compose restart` to restart ...
    - `docker-compose stop` to stop ...
    - `docker-compose rm` to delete ...
  - can (and should) be extended for other service dependencies for the application

- Continuous Integration (CI)
  - Run full build/test scripts, breaking on any errors
  - Final process is creating a Production Docker image to deploy to Test/Prod servers
  - Here is a sample of the docker build command for a CI image
    - NOTE: while this suggests a 1:1 relationship between CI image and project, the container should be able to be reused to build other projects provided the credentials are the same.

  ```
  docker build \
    --build-arg USER_NAME="<user_name>" \
    --build-arg USER_PASS="<user_pass>" \
    --build-arg USER_SSH="$(cat ~/.ssh/id_rsa)" \
    --build-arg USER_SSH_PUB="$(cat ~/.ssh/id_rsa.pub)" \
    --build-arg IMAGE_PROJECT="git@github.com:<user_name>/repo.git" \
    --build-arg IMAGE_TYPE="development" \
    -t <user_name>/<project_name>:ci .
  ```

- Production image
  - Here is a sample of the docker build command for a Production image

  ```
  docker build \
    --build-arg APP_SOURCE="<compressed_app_structure>" \
    -t <user_name>/<project_name>:<project_version> .
  ```
