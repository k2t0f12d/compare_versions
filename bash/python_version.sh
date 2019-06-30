#!/usr/bin/env bash

# FILE: python_version.sh
#
# Get the installed python interpreter version

# USAGE
#
# Source this script to load the function, and its test harness.
# Testing will be triggered with environment variable ENABLE_TESTS set.
#
# Invoke python_version with no arguments.
#
# Function echoes the installed python interperter version. Capture this
# output by assigning it to an appropriate variable.
#
# Check the BASH special variable `$?` for the return status, as follows:
#
# 0   - python version is discovered
# 1   - python version cannot be discovered
#
# EXAMPLE
#
# . /path/to/python_version.sh
# LOCAL_PYTHON_VERSION=$(python_version)
# EXIT_STATUS=$?
# if ! [[ $EXIT_STATUS -eq 0 ]] || [[ -z $LOCAL_PYTHON_VERSION ]]; then
#       echo "Failed to retrieve python interpreter version"
#       return $EXIT_STATUS
# fi
#

# NOTE: uncomment the following to enable debugging output from BASH
#set -x

python_version() {
        command -v python 2>&1 >/dev/null
        if [[ $? -ne 0 ]]; then
                command -v python3 2>&1 >/dev/null
                if [[ $? -ne 0 ]]; then
                        return 1
                fi
        else
                # NOTE: Redirect stderr to stdout to get the output of older pythons.
                [[ "$(python -V 2>&1)" =~ [0-9]+(.[0-9]+)?(.[0-9]+)? ]]
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
        echo 'FAIL: Add some tests!!!'
fi

echo 'Finished loading `python_version()` :)'
