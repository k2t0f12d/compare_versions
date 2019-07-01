#!/usr/bin/env bash

# FILE: pyenv_version.sh
#
# Get the installed pyenv python environment manager version

# USAGE
#
# Source this script to load the function, and its test harness.
# Testing will be triggered with environment variable ENABLE_TESTS set.
#
# Invoke pyenv_version with no arguments.
#
# Function echoes the installed pyenv version. Capture this
# output by assigning it to an appropriate variable.
#
# Check the BASH special variable `$?` for the return status, as follows:
#
# 0   - pyenv version is discovered
# 1   - pyenv version cannot be discovered
#
# EXAMPLE
#
# . /path/to/pyenv_version.sh
# PYENV_VERSION=$(pyenv_version)
# EXIT_STATUS=$?
# if ! [[ $EXIT_STATUS -eq 0 ]] || [[ -z $PYENV_VERSION ]]; then
#       echo "Failed to retrieve pyenv version"
#       return $EXIT_STATUS
# fi
#

# NOTE: uncomment the following to enable debugging output from BASH
#set -x

pyenv_version() {
        command -v pyenv 2>&1 >/dev/null
        if [[ $? -ne 0 ]]; then
                if ! [[ -f $HOME/.pyenv/bin/pyenv ]]; then
                        return 1
                else
                        echo "pyenv exists but is not in \$PATH"
                fi
                return 1
        else
                [[ "$(pyenv --version)" =~ [0-9]+(.[0-9]+)?(.[0-9]+)? ]]
                if [[ -n $BASH_REMATCH ]]; then
                        echo $BASH_REMATCH
                        return 0
                elif [[ -n $MATCH ]]; then
                        echo $MATCH
                        return 0
                else
                        return 1
                fi
        fi
}

if [[ $ENABLE_TESTS ]]; then
        echo 'Loading `python_version()`...'
        echo "Running the test suite..."
        echo '>>>>>>>>>> These tests should pass'
        function pyenv() { echo -n "1.0.0"; return 0; }
        exit_status=$?
        PYENV_VERSION=$(pyenv_version)
        if ! [[ $exit_status ]] || [[ -z $PYENV_VERSION ]]; then
                echo "FAIL: expected '1.0.0' but got nothing pyenv version'"
        elif [[ $exit_status ]] && [[ $PYENV_VERSION =~ [0-9]+(.[0-9]+)?(.[0-9]+)? ]]; then
                if [[ -n $BASH_REMATCH ]] && [[ $BASH_REMATCH == "1.0.0" ]]; then
                        echo "PASS: expected '1.0.0' and got $PYENV_VERSION for pyenv version"
                elif [[ -n $MATCH ]] && [[ $MATCH == "1.0.0" ]]; then
                        echo "PASS: expected '1.0.0' and got $PYENV_VERSION for pyenv version"
                else
                        echo "FAIL: cannot retrieve pyenv version"
                fi
        fi
        unset PYENV_VERSION
        unset BASH_REMATCH
        unset MATCH MATCH
        unset -f pyenv
fi

echo 'Finished loading `pyenv_version()` :)'
