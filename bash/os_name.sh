#!/usr/bin/env bash

# FILE: os_name.sh
#
# Get the operating system name

# USAGE
#
# Source this script to load the function, and its test harness.
# Testing will be triggered with environment variable ENABLE_TESTS set.
#
# Invoke os_name with no arguments.
#
# Function echoes the operating system name. Capture this output by assigning
# it to an appropriate variable.
#
# Check the BASH special variable `$?` for the return status, as follows:
#
# 0   - os name is discovered
# 1   - os name cannot be discovered
#
# EXAMPLE
#
# . /path/to/os_name.sh
# OSNAME=$(os_name)
# EXIT_STATUS=$?
# if ! [[ $EXIT_STATUS -eq 0 ]] || [[ -z $OSNAME ]]; then
#       echo "Failed to retrieve operating system name"
#       return $EXIT_STATUS
# fi
#

# NOTE: uncomment the following to enable debugging output from BASH
#set -x

os_name() {
        command -v uname 2>&1 >/dev/null
        if [[ $? -eq 0 ]]; then
                CANONICAL_NAME=$(uname -s | tr '[A-Z]' '[a-z]')
                [[ -z ${CANONICAL_NAME} ]] && return 1
        fi

        [[ "${CANONICAL_NAME}" =~ linux ]]
        if [[ ${BASH_REMATCH} == "linux" ]]; then
                echo ${BASH_REMATCH}
                return 0
        elif [[ ${MATCH} == "linux" ]]; then
                echo ${MATCH}
                return 0
        fi

        [[ "${CANONICAL_NAME}" =~ freebsd ]]
        if [[ ${BASH_REMATCH} == "freebsd" ]]; then
                echo ${BASH_REMATCH}
                return 0
        elif [[  ${MATCH} == "freebsd" ]]; then
                echo ${MATCH}
                return 0
        fi

        [[ "${CANONICAL_NAME}" =~ darwin ]]
        if [[ ${MATCH}  == "darwin" ]]; then
                command -v sw_vers 2>&1 >/dev/null
                if [[ $? -eq 0 ]]; then
                        echo $(sw_vers -productName | sed -e 's/\ //g' | tr '[A-Z]' '[a-z]')
                        return 0
                fi
        elif [[ ${BASH_REMATCH} == "darwin" ]]; then
                command -v sw_vers 2>&1 >/dev/null
                if [[ $? -eq 0 ]]; then
                        echo $(sw_vers -productName | sed -e 's/\ //g' | tr '[A-Z]' '[a-z]')
                        return 0
                fi
        fi

        [[ "${CANONICAL_NAME}" =~ mingw ]]
        if [[ ${MATCH}  == "mingw" ]]; then
                echo "windows"
                return 0
        elif [[ ${BASH_REMATCH} == "mingw" ]];  then
                echo "windows"
                return 0
        fi

        [[ "${CANONICAL_NAME}" =~ cygwin ]]
        if [[ ${MATCH}  == "cygwin" ]]; then
                echo "windows"
                return 0
        elif [[ ${BASH_REMATCH} == "cygwin" ]];  then
                echo "windows"
                return 0
        fi

        return 1
}

if [[ $ENABLE_TESTS ]]; then
        echo 'Loading `os_name()`...'
        echo "Running the test suite..."
        echo ">>>>>>>>>> These tests should pass"
        function uname() { echo -n 'linux'; }
        unset MATCH match
        OS=$(os_name)
        if [[ $OS == "linux" ]]; then
                echo "PASS: name linux returns $OS"
        fi
        unset OS
        unset MATCH match
        unset -f uname

        function uname() { echo -n 'freebsd'; }
        unset MATCH match
        OS=$(os_name)
        if [[ $OS == "freebsd" ]]; then
                echo "PASS: name freebsd returns $OS"
        fi
        unset OS
        unset MATCH match
        unset -f uname

        function uname() { echo -n 'darwin'; }
        function sw_vers() { echo -n 'Mac OS X'; }
        unset MATCH match
        OS=$(os_name)
        if [[ $OS == "macosx" ]]; then
                echo "PASS: name darwin returns $OS"
        fi
        unset OS
        unset MATCH match
        unset -f uname
        unset -f sw_vers

        function uname() { echo -n 'mingw'; }
        unset MATCH match
        OS=$(os_name)
        if [[ $OS == "windows" ]]; then
                echo "PASS: name mingw returns $OS"
        fi
        unset OS
        unset MATCH match
        unset -f uname

        function uname() { echo -n 'cygwin'; }
        unset MATCH match
        OS=$(os_name)
        if [[ $OS == "windows" ]]; then
                echo "PASS: name cygwin returns $OS"
        fi
        unset OS
        unset MATCH match
        unset -f uname

        echo ">>>>>>>>>> This test should fail"
        function uname() { echo -n 'foo'; }
        unset MATCH match
        OS=$(os_name)
        if [[ $? -eq 1 ]] && [[ -z $OS ]]; then
                echo "FAIL: name foo fails"
        fi
        unset OS
        unset MATCH match
        unset -f uname
fi

echo 'Finished loading `os_name()` :)'
