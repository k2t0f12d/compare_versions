#!/usr/bin/env bash

# FILE: install_pyenv.sh
#
# Install pyenv on the running system

# USAGE
#
# Source this script to load the function, and its test harness.
# Testing will be triggered with environment variable ENABLE_TESTS set.
#
# Invoke install_pyenv with one argument, the filename and fullpath to
# the shell's rc file. This can be obtained with the `shell_rc_file()`
# function in the shell_rc_file.sh scriplet.
#
# Check the BASH special variable `$?` for the return status, as follows:
#
# 0   - pyenv installed successfully
# 1   - pyenv cannot be installed
#
# EXAMPLE
#
# . /path/to/install_pyenv.sh
# install_pyenv
# EXIT_STATUS=$?
# if ! [[ $EXIT_STATUS -eq 0 ]]; then
#       echo "Failed to install pyenv"
#       return $EXIT_STATUS
# fi
#
# DEPENDENCIES
#
# This function depends on the function `shell_rc_file` from the
# shell_rc_file.sh scriptlet.

# NOTE: uncomment the following to enable debugging output from BASH
#set -x

install_pyenv() {
        if ! test -d $HOME/.pyenv; then
                curl -s https://pyenv.run | bash
        elif [[ $(command -v pyenv 2P&1 >/dev/null) ]]; then
                echo "pyenv is already installed"
                return 1
        elif [[ -f $HOME/.pyenv/bin/pyenv ]]; then
                echo "pyenv is installed but not in $PATH"
                return 1
        fi

        RCFILE=$1

        if [[ -z "$(grep '.pyenv/bin' $RCFILE)" ]]; then
                echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> $RCFILE
        fi
        if [[ -z "$(grep 'pyenv init' $RCFILE)" ]]; then
                echo 'eval "$(pyenv init -)"' >> $RCFILE
        fi
        if [[ -z "$(grep 'pyenv virtualenv-init' $RCFILE)" ]]; then
                echo 'eval "$(pyenv virtualenv-init -)"' >> $RCFILE
        fi

        source $RCFILE

        if ! test -d $HOME/.pyenv/plugins/pyenv-alias; then
                git clone https://github.com/s1341/pyenv-alias.git $(pyenv root)/plugins/pyenv-alias
        fi
}

if [[ $ENABLE_TESTS ]]; then
        echo 'Loading `install_pyenv()`...'
        echo "Running the test suite..."
        echo '>>>>>>>>>> These tests should pass'
        echo 'FAIL: Write some tests!!!'
fi

echo 'Finished loading `install_pyenv()` :)'
