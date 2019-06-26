#!/usr/bin/env bash

# FILE: shell_rc_file.sh
#
# Get the shell rc file

# USAGE
#
# Source this script to load the function, its test harness.
# Testing will be triggered with environment variable ENABLE_TESTS set.
#
# Invoke shell_rc_file with no arguments.
#
# Function echoes the full path and filename for the rc file. Capture this
# output by assigning an appropriate variable.
#
# Check the BASH special variable `$?` for the return status, as follows:
#
# 0   - file is discovered and it exists
# 1   - file and path can be determined, but it doesn't exist
# 255 - the shell source is not able to be determined, or
#       the rc file and path cannot be determined
#
# EXAMPLE
#
# RCFILE=$(shell_rc_file)
#

# NOTE: uncomment the following to enable debugging output from BASH
#set -x

shell_rc_file() {
        if [[ -z "${SHELL}" ]] || [[ -z "${HOME}" ]]; then
                return 255
        fi

        SHELL_NAME=${SHELL##*\/}
        if ! [[ -f "${HOME}/.${SHELL_NAME}rc" ]]; then
                return 1
        fi

        echo "${HOME}/.${SHELL_NAME}rc"
        return 0
}

if [[ $ENABLE_TESTS ]]; then
        echo "Running the test suite..."
        OLD_SHELL=$SHELL
        unset SHELL
        RCFILE=$(shell_rc_file)
        if [[ $? -eq 255 ]]; then
                echo "PASS: Environment shell not set"
        else
                echo "FAIL: Environment shell is set when it should not be"
        fi
        
        SHELL="foo"
        RCFILE=$(shell_rc_file)
        if [[ $? -eq 1 ]]; then
                echo "PASS: Foo rc file doesn't exist"
        else
                echo "FAIL: Foo rc file exits when it shouldn't"
        fi
        
        touch "${HOME}/.${SHELL}rc"
        RCFILE=$(shell_rc_file)
        if [[ $? -eq 0 ]]; then
                echo "PASS: Foo rc file exists"
        else
                echo "FAIL: Foo rc file doesn't exist when it should"
        fi

        if [[ "${RCFILE}" == "${HOME}/.${SHELL}rc" ]]; then
                echo "PASS: Function output rc filename $RCFILE"
        else
                echo "FAIL: Incorrect output: Got $RCFILE"
        fi

        rm $RCFILE
        unset RCFILE
        SHELL=$OLD_SHELL
        unset OLD_SHELL
fi
