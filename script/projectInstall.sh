#!/bin/bash

###
# project install script for project dependencies
#   - this can and should be run as needed in development environment to update project dependencies
#       - example: re-running "npm-install" to update versions
###

# Constants
DIVIDER="===================="
TEMPLATE="\n\n${DIVIDER}${DIVIDER}${DIVIDER}\n%s\n\n\n"

# Script
if [[ $1 ]]
then

    printf "${TEMPLATE}" "Getting project source code"

    ###
    # NOTE: add "git clone" call here to get project source code
    ###

fi



if [[ "$1" == "production" ]]
then

    printf "${TEMPLATE}" "Installing production-specific dependencies"

    if [[ -f package.json ]]
    then
        printf "${TEMPLATE}" "Installing Node Dependencies"

        npm install --$1
    fi

    ###
    # NOTE: install production-specific project dependencies here
    #   - example: npm install --$1
    ###

else

    printf "${TEMPLATE}" "Installing Node Global Dependencies"

    ###
    # NOTE: global packages are personal preference here...
    #   - swap these out with project-specific global dependencies
    ###
    npm install -g \
        babel \
        babel-eslint \
        bower \
        browserify \
        eslint \
        gulp \
        istanbul \
        karma-cli \
        mocha \
        protractor

    if [[ -f bower.json ]]
    then
        printf "${TEMPLATE}" "Installing Bower Dependencies"

        bower install
    fi

    if [[ -f package.json ]]
    then
        printf "${TEMPLATE}" "Installing Node Dependencies"

        npm install
    fi

    ###
    # NOTE: install development-specific project dependencies here
    ###

fi

printf "${TEMPLATE}" "Removing project files/folders"

###
# NOTE: remove any additional project-specific files/folders
###
rm -rf \
    ${HOME_DIR}/.npm \
    ${HOME_DIR}/.node-gyp
