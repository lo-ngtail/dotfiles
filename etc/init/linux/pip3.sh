#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

# If you don't have pip or don't find pip preserved
# in a directory with the path,
# to install it after the platforms are detected
if ! has "pip3"; then

    # Install pip
    case "$(get_os)" in
        # Case of OS X
        osx)
            if has "brew"; then
                log_echo "Install pip with Homebrew"
                brew install pip3
            elif "port"; then
                log_echo "Install pip with MacPorts"
                sudo port install python3-pip
            else
                log_fail "error: require: Homebrew or MacPorts"
                exit 1
            fi
            ;;

        # Case of Linux
        linux)
            if has "yum"; then
                log_echo "Install pip with Yellowdog Updater Modified"
                sudo -E yum -y install python3-pip
            elif has "apt-get"; then
                log_echo "Install pip with Advanced Packaging Tool"
                sudo -E apt-get -y install python3-pip
            else
                log_fail "error: require: YUM or APT"
                exit 1
            fi
            ;;

        # Other platforms such as BSD are supported
        *)
            log_fail "error: this script is only supported osx and linux"
            exit 1
            ;;
    esac
fi

log_pass "pip: installed successfully"
