#!/bin/bash

###
# environment install script for Alpine Linux on Docker
###

# Constants
DIVIDER="===================="
TEMPLATE="\n\n${DIVIDER}${DIVIDER}${DIVIDER}\n%s\n\n\n"

printf "${TEMPLATE}" "Installing Alpine Linux Packages"

###
# NOTE: packages for env improvements are another personal preference here... (10MB penalty)
#   - coreutils curl git grep openssh tar tree
#
# NOTE: additional packages for NodeJS compile
#   - binutils-gold g++ gcc libgcc libstdc++ linux-headers make python
#
# NOTE: add/remove additional packages here
###
apk add \
    coreutils \
    curl \
    git \
    grep \
    openssh \
    tar \
    tree \
    binutils-gold \
    g++ \
    gcc \
    libgcc \
    libstdc++ \
    linux-headers \
    make \
    python

# create user account
printf "${TEMPLATE}" "Creating User Account"

adduser -s /bin/bash -D -G wheel -S ${USER_NAME}
printf "${USER_NAME}:`echo ${USER_PASS} | sha256sum`" | chpasswd

chown -R ${USER_NAME}:root /script

mkdir -p ${HOME_DIR}/${WORK_DIR}



# TODO: investigate using shared libraries for:
#   - libuv
#   - openssl
#   - zlib
printf "${TEMPLATE}" "Installing Node v${NODE_VER}"

curl -sSL https://nodejs.org/dist/v${NODE_VER}/node-v${NODE_VER}.tar.gz | tar -xz

cd /node-v${NODE_VER}

./configure --prefix=${NODE_DIR} --without-snapshot --fully-static
make -j$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1)
make install

chown -R ${USER_NAME} ${NODE_DIR}



###
# NOTE: inject additinal environment installations here
#   - example: NodeJS compile
###



###
# NOTE: additional packages for dev environment are another personal preference here...
#   - samba samba-common-tools
#
# TODO: follow up on Node SASS linting project to remove this requirement and reduce development image size
#   - ruby ruby-bundler
#
# TODO: debug Samba setup and configuration
###
if [[ "$1" != "production" ]]
then

    printf "${TEMPLATE}" "Installing File Share Dependencies"

    apk add samba samba-common-tools

    (echo "${USER_PASS}"; echo "${USER_PASS}") | smbpasswd -s -a ${USER_NAME}

    printf "%s\n" \
        "[global]" \
        "security = user" \
        "encrypt passwords = yes" \
        "unix password sync = yes" \
        "" \
        "[${WORK_DIR}]" \
        "path = ${HOME_DIR}/${WORK_DIR}" \
        "available = yes" \
        "valid users = ${USER_NAME}" \
        "read only = no" \
        "browsable = yes" \
        "public = yes" \
        "writable = yes" \
    >> /etc/samba/smb.conf

    printf "${TEMPLATE}" "Installing Ruby and scss_lint Dependencies"

    apk add ruby ruby-bundler

    gem install scss_lint



elif [[ "$1" == "production" ]]
then

    printf "${TEMPLATE}" "Removing Alpine Linux Packages"

    ###
    # NOTE: remove packages for production image
    #   - coreutils curl git grep openssh tar tree
    #   - keeping [bash-completion, coreutils, grep, openssh, tree] for accessing image remotely
    #
    # NOTE: remove required packages for node/npm download and compile
    #   - binutils-gold g++ gcc libgcc libstdc++ linux-headers make python
    #
    # NOTE: remove additional packages required for environment install here
    ###
    apk del \
        curl \
        git \
        tar \
        binutils-gold \
        g++ \
        gcc \
        libgcc \
        libstdc++ \
        linux-headers \
        make \
        python



    printf "${TEMPLATE}" "other unnecessary files"

    ###
    # NOTE: add additional file/folder removal here for production image only
    ###
    rm -rf \
        /etc/ssl \
        /opt/node/include \
        /opt/node/lib/node_modules/npm/man \
        /opt/node/lib/node_modules/npm/doc \
        /opt/node/lib/node_modules/npm/html \
        /opt/node/share/man

fi

# remove apk cache and list
printf "${TEMPLATE}" "Alpine Linux Package Cache and Node"

###
# NOTE: add additional file/folder removal here for all images
###
rm -rf \
    /node-v${NODE_VER} \
    /tmp/* \
    /var/cache/apk/*
