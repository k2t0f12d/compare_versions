#!/usr/bin/env bash

# FILE: os_version.sh
#
# Get the operating system version

# USAGE
#
# Source this script to load the function, and its test harness.
# Testing will be triggered with environment variable ENABLE_TESTS set.
#
# Invoke os_version with one argument, the name of the operating system.
# This argument should be in lower case and match the output of the
# `os_name()`, script.
#
# Function echoes the operating system version. Capture this output by assigning
# it to an appropriate variable.
#
# Check the BASH special variable `$?` for the return status, as follows:
#
# 0   - os version is discovered
# 1   - os version cannot be discovered
#
# EXAMPLE
#
# . /path/to/os_name.sh
# . /path/to/os_version.sh
# OSVERS=$(os_version $(os_name))
# EXIT_STATUS=$?
# if ! [[ $EXIT_STATUS -eq 0 ]] || [[ -z $OSVERS ]]; then
#       echo "Failed to retrieve operating system version"
#       return $EXIT_STATUS
# fi
#

# NOTE: uncomment the following to enable debugging output from BASH
#set -x

os_version() {
        if [[ -z $1 ]]; then
                echo "The operating system name must be supplied" && return 1
        fi
        OS=$( echo $1 | tr '[A-Z]' '[a-z]' )
        if [[ -z $OS ]]; then
                echo "The operating system name must be supplied" && return 1
        fi

        case "${OS}" in
        linux)  command -v lsb_release 2>&1 >/dev/null
                if [[ $? -eq 0 ]]; then
                        version=`lsb_release -r -s`
                        if ! [[ $version =~ [0-9]+(.[0-9]+)?(.[0-9]+)? ]] || \
                             [[ -z $version ]]; then
                                return 1
                        else
                                echo $version
                                return 0
                        fi
                elif test -f /etc/os-release; then
                        if [[ -f /etc/os-release ]]; then
                                source <(grep ^VERSION_ID /etc/os-release)
                                if [[ -z $VERSION_ID ]]; then
                                        return 1
                                else
                                        echo $VERSION_ID
                                        return 0
                                fi
                        fi
                fi ;;
        freebsd) command -v freebsd-version 2>&1 >/dev/null
                 if [[ $? -eq 0 ]]; then
                         [[ `freebsd-version` =~ [0-9]+(.[0-9]+)?(.[0-9]+)? ]]
                         if [[ -n ${BASH_REMATCH} ]]; then
                                 echo ${BASH_REMATCH}
                                 return 0
                         elif [[ -n ${MATCH} ]]; then
                                 echo ${MATCH}
                                 return 0
                         fi
                 else
                         return 1
                 fi ;;
        macosx) command -v sw_vers 2>&1 >/dev/null
                if [[ $? -eq 0 ]]; then
                        echo $(sw_vers -productVersion)
                        return 0
                fi
                command -v defaults 2>&1 >/dev/null
                if [[ $? -eq 0 ]]; then
                        echo $(defaults read loginwindow SystemVersionStampAsString)
                        return 0
                fi

                return 1
                ;;
        windows) ;;
        *) ;;
        esac

        return 1
}

if [[ $ENABLE_TESTS ]]; then
        echo 'Loading `os_version()`...'
        echo "Running the test suite..."
        echo '>>>>>>>>>> These tests should pass'
        function lsb_release() { echo -n "1.0.0" }
        exit_status=$?
        OSVER=$(os_version "linux")
        if ! [[ $exit_status ]] || [[ -z $OSVER ]]; then
                echo "FAIL: expected '1.0.0' but got nothing for OS name 'linux'"
        elif [[ $exit_status ]] && [[ $OSVER =~ [0-9]+(.[0-9]+)?(.[0-9]+)? ]]; then
                if [[ -n $BASH_REMATCH ]] && [[ $BASH_REMATCH == "1.0.0" ]]; then
                        echo "PASS: expected '1.0.0' and got $OSVER for OS name 'linux'"
                elif [[ -n $MATCH ]] && [[ $MATCH == "1.0.0" ]]; then
                        echo "PASS: expected '1.0.0' and got $OSVER for OS name 'linux'"
                else
                        echo "FAIL: cannot retrieve OS version"
                fi
        fi
        unset OSVER
        unset BASH_REMATCH
        unset MATCH MATCH
        unset -f lsb_release

        function freebsd-version() { echo -n "1.0.0" }
        exit_status=$?
        OSVER=$(os_version "freebsd")
        if ! [[ $exit_status ]] || [[ -z $OSVER ]]; then
                echo "FAIL: expected '1.0.0' but got nothing for OS name 'freebsd'"
        elif [[ $exit_status ]] && [[ $OSVER =~ [0-9]+(.[0-9]+)?(.[0-9]+)? ]]; then
                if [[ -n $BASH_REMATCH ]] && [[ $BASH_REMATCH == "1.0.0" ]]; then
                        echo "PASS: expected '1.0.0' and got $OSVER for OS name 'freebsd'"
                elif [[ -n $MATCH ]] && [[ $MATCH == "1.0.0" ]]; then
                        echo "PASS: expected '1.0.0' and got $OSVER for OS name 'freebsd'"
                else
                        echo "FAIL: cannot retrieve OS version"
                fi
        fi
        unset OSVER
        unset BASH_REMATCH
        unset MATCH MATCH
        unset -f freebsd-version

        function sw_vers() { echo -n "1.0.0" }
        exit_status=$?
        OSVER=$(os_version "macosx")
        if ! [[ $exit_status ]] || [[ -z $OSVER ]]; then
                echo "FAIL: expected '1.0.0' but got nothing for OS name 'macosx'"
        elif [[ $exit_status ]] && [[ $OSVER =~ [0-9]+(.[0-9]+)?(.[0-9]+)? ]]; then
                if [[ -n $BASH_REMATCH ]] && [[ $BASH_REMATCH == "1.0.0" ]]; then
                        echo "PASS: expected '1.0.0' and got $OSVER for OS name 'macosx'"
                elif [[ -n $MATCH ]] && [[ $MATCH == "1.0.0" ]]; then
                        echo "PASS: expected '1.0.0' and got $OSVER for OS name 'macosx'"
                else
                        echo "FAIL: cannot retrieve OS version"
                fi
        fi
        unset OSVER
        unset BASH_REMATCH
        unset MATCH MATCH
        unset -f sw_vers

        echo ">>>>>>>>>> These tests should fail"
        function lsb_release() { return 1; }
        exit_status=$?
        OSVER=$(os_version "linux")
        if ! [[ $exit_status ]] || [[ -z $OSVER ]]; then
                echo "FAIL: expected '1.0.0' but got nothing for OS name 'linux'"
        elif [[ $exit_status ]] && [[ $OSVER =~ [0-9]+(.[0-9]+)?(.[0-9]+)? ]]; then
                if [[ -n $BASH_REMATCH ]] && [[ $BASH_REMATCH == "1.0.0" ]]; then
                        echo "PASS: expected '1.0.0' and got $OSVER for OS name 'linux'"
                elif [[ -n $MATCH ]] && [[ $MATCH == "1.0.0" ]]; then
                        echo "PASS: expected '1.0.0' and got $OSVER for OS name 'linux'"
                else
                        echo "FAIL: cannot retrieve OS version"
                fi
        fi
        unset OSVER
        unset BASH_REMATCH
        unset MATCH MATCH
        unset -f lsb_release

        OSVER=$(os_version "foo")
        if ! [[ $exit_status ]] || [[ -z $OSVER ]]; then
                echo "FAIL: got no version string for OS name 'foo'"
        elif [[ $exit_status ]] && [[ $OSVER =~ [0-9]+(.[0-9]+)?(.[0-9]+)? ]]; then
                if [[ -n $BASH_REMATCH ]] && [[ $BASH_REMATCH == "1.0.0" ]]; then
                        echo "PASS: got '$OSVER' for OS name 'foo'"
                elif [[ -n $MATCH ]] && [[ $MATCH == "1.0.0" ]]; then
                        echo "PASS: got '$OSVER' for OS name 'foo'"
                else
                        echo "FAIL: cannot retrieve OS version for OS name 'foo'"
                fi
        fi
        unset OSVER
        unset BASH_REMATCH
        unset MATCH MATCH
fi

echo 'Finished loading `os_version()` :)'
