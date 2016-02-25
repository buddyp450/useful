#!/bin/bash
# Invokes nvm exec npm install followed by nvm exec npm start on the local module
# NVM will be installed if it doesn't already exist in the home directory where executed
# See: https://github.com/creationix/nvm for details on installing/uninstalling NVM
# Will only invoke nvm exec npm install if node_modules is not found for the local module
# Uses nvm v0.31.0 currently but will install whatever version is specified by the local module's .nvmrc
# Will not change the system wide node version obtained from the shell with 'node -v'
deploy() {
    load_nvm
    command -v nvm >/dev/null 2>&1 || { install_nvm; }
    echo "Deploying just-grep-it..."
    if [ ! -d "node_modules" ]; then
        nvm exec npm install
    fi
    nvm exec npm start
}
load_nvm() {
    if [ -z "$NVM_DIR" ]; then
        export NVM_DIR="$HOME/.nvm" # default nvm install path
    fi
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" >/dev/null 2>&1
}
install_nvm() {
    read -p "Was unable to find nvm, would you like to install it now? (this is a requirement) [Y/n]:" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" >/dev/null 2>&1
        nvm install
    else
        echo "Deployment Aborted" >&2
        exit 1
    fi
}
deploy
