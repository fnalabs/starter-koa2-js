# docker-nodejs-starter
Starter kit for server-side only Node.js with Koa2 applications running on Alpine Linux.

## Overview
Overall, this starter kit provides the standard boilerplate constructs to develop and build a Node.js applcation. It provides ES2015+ through Babel with `async/await` support from ES2017 for Koa2 implemenations. It has configurable project settings rather than a heavy handed approach with included \*rc/\*ignore files for:
- [Babel](https://babeljs.io/) ([.babelrc](./.babelrc) for development, see build config for production code)
- [ESLint](http://eslint.org/) ([.eslintrc](./.eslintrc))
- [JSBeautify](http://jsbeautifier.org/) ([.jsbeautifyrc](./.jsbeautifyrc) also includes beautify settings for HTML and CSS)
- [Git](https://git-scm.com/) ([.gitignore](./.gitignore), pretty much the standard Node.js one provided by Github)
- [Docker](https://www.docker.com/) ([.dockerignore](./.dockerignore), pretty much the .gitignore above with a few small changes)

Also, it provides an extensible build process integrated with npm scripts and Gulp under the hood when necessary to simplify build needs rather than rolling your own custom scripts. The [gulpfile](./gulpfile.babel.js), written in ES2015+, is paired with a [build config](./conf/buildConfig.json) to help manage the complexity that build processes can sometimes require. The following is a breakdown of npm scripts provided and how to use them:
- `npm run build` A basic wrapper to build production output.
- `npm start` A basic script to start the application in a production environment.
- `npm run start:dev` A basic script to start the application in a development environment.

- **NOTE:** This requires the `gulp-cli` package to be installed globally in order to work.

## Docker
As mentioned previously, I have included full Docker support for development and production environments.

For development, it is strongly recommended to use `docker-compose` with the included [docker-compose.yml](./docker-compose.yml) file to achieve this. It provides a sandboxed evironment for development that is consistent throughout the whole life cycle of the application. Below is a summary of useful `docker-compose` CLI commands.
- `docker-compose build` to build the development image.
- `docker-compose up [--build]` to (re)create/start and optionally build the development container.
- `docker-compose restart` to restart ...
- `docker-compose stop` to stop ...
- `docker-compose rm` to delete ...
- `docker-compose down` to stop and remove ...

For production, builds are a multi-step process that is easily automated. Below is a short script to achieve this goal.
```
npm run build
docker build -t aeilers/docker-nodejs .
```

## Guarantees
[There are none](./LICENSE).
