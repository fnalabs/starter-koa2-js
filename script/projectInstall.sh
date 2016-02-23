#!/bin/bash

###
# project install script for project dependencies
#   - this can and should be run as needed in dev environment to update project dependencies
#       - example: re-running "npm-install" to update versions
###

DIVIDER="===================="
TEMPLATE="\n\n${DIVIDER}${DIVIDER}${DIVIDER}\n%s\n\n\n"

if [[ "$1" == "prod" ]]
then

    if [[ -f ./package.json ]]
    then
        printf "${TEMPLATE}" "Installing (Production) Node Dependencies"

        npm install --$1
    fi

    ###
    # NOTE: install prod-specific project dependencies here
    #   - example: npm install --$1
    ###

else

    printf "${TEMPLATE}" "Installing (Global) Node Dependencies"

    npm install -g \
        bower \
        gulp \
        protractor

    webdriver-manager update

    if [[ -f ./package.json ]]
    then
        printf "${TEMPLATE}" "Installing (All) Node Dependencies"

        npm install
    fi

    if [[ -f ./bower.json ]]
    then
        printf "${TEMPLATE}" "Installing Bower Dependencies"

        bower install
    fi

    ###
    # NOTE: install dev-specific project dependencies here
    ###

fi

###
# NOTE: remove any additional project-specific files/folders
###
printf "${TEMPLATE}" "Clearing Node and NPM cache"

rm -rf \
    ${HOME_DIR}/.npm \
    ${HOME_DIR}/.node-gyp
