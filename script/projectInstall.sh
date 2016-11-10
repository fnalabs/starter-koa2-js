#!/bin/bash

###
# project install script for project dependencies
#   - this can and should be run as needed in dev environment to update project dependencies
#       - example: re-running "npm install" to update versions
###
runProject () {
    local DIVIDER="===================="
    local TEMPLATE="\n\n${DIVIDER}${DIVIDER}${DIVIDER}\n%s\n\n\n"

    if [[ "${NODE_ENV}" == "production" ]]
    then
        npm install --production
    else

        if [[ -f ./package.json ]]
        then
            # NOTE: add any packages required for node dependencies
            # e.g. apk add tar

            # NOTE: add any node global dependencies
            # printf "${TEMPLATE}" "Installing (Global) Node Dependencies"
            # e.g. npm install -g gulp

            printf "${TEMPLATE}" "Installing (All) Node Dependencies"
            npm install
        fi

        if [[ -f ./bower.json ]]
        then
            printf "${TEMPLATE}" "Installing Bower Dependencies"
            npm install -g bower
            bower install
        fi

    fi

    ###
    # NOTE: remove any additional project-specific files/folders
    ###
    printf "${TEMPLATE}" "Clearing Node and NPM cache"
    clearProjectInstallCache
    clearApkCache
}

clearProjectInstallCache () {
    rm -rf \
        ${HOME_DIR}/.npm \
        ${HOME_DIR}/.node-gyp
}

source /etc/profile && runProject
