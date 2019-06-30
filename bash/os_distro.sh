#!/usr/bin/env bash

# FILE: os_distro.sh
#
# Get the distribution name for the OS

# USAGE
#
# Source this script to load the function, and its test harness.
# Testing will be triggered with environment variable ENABLE_TESTS set.
#
# Invoke os_distro with one argument, a string containing the OS name.
# The OS name should correlate to the output of the `os_name()` function.
# See the file "os_name.sh" for more details.
#
# Function echoes the operating system distribution name. Capture this output by
# assigning it to an appropriate variable.
#
# Check the BASH special variable `$?` for the return status, as follows:
#
# 0   - os distro name is discovered
# 1   - os distro name cannot be discovered
#
# EXAMPLE
#
# . /path/to/os_distro.sh
# OSDISTRO=$(os_distro)
# EXIT_STATUS=$?
# if ! [[ $EXIT_STATUS -eq 0 ]] || [[ -z $OSDISTRO ]]; then
#       echo "Failed to retrieve operating system distribution"
#       return $EXIT_STATUS
# fi
#

# NOTE: uncomment the following to enable debugging output from BASH
#set -x

os_distro() {
        if [[ -z $1 ]]; then
                echo "The operating system name must be supplied" && return 1
        fi
        OS=$( echo $1 | tr '[A-Z]' '[a-z]' )
        if [[ -z $OS ]]; then
                echo "The operating system name must be supplied" && return 1
        fi

        case "${OS}" in
        linux)  command -v lsb_release 2>&1 >/dev/null
                if test $? -eq 0; then
                        distro=`lsb_release -i -s | tr '[A-Z]' '[a-z]'`
                        if [[ -z $distro ]]; then
                                return 1
                        else
                                echo $distro
                                return 0
                        fi
                elif test -f /etc/os-release; then
                        source <(grep ^ID /etc/os-release)
                        echo $ID
                        return 0
                fi ;;
        freebsd) ;;
        macosx) ;;
        windows) ;;
        *) ;;
        esac

        return 1
}

if [[ $ENABLE_TESTS ]]; then

        echo 'Loading `os_distro()`...'
        echo "Running the test suite..."
        echo '>>>>>>>>>> These tests should pass'
fi

echo 'Finished loading `os_distro()` :)'
