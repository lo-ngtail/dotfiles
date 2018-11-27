#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

# If you don't have python3 or don't find python preserved
# in a directory with the path,
# to install it after the platforms are detected
if ! has "python3"; then

    # Install python3 
    case "$(get_os)" in
        # Case of OS X
        osx)
            if has "brew"; then
                log_echo "Install python3 with Homebrew"
                brew install python3
            elif "port"; then
                log_echo "Install python3 with MacPorts"
                sudo port install python3
            else
                log_fail "error: require: Homebrew or MacPorts"
                exit 1
            fi
            ;;

        # Case of Linux
        linux)
            if has "yum"; then
                log_echo "Install python3 with Yellowdog Updater Modified"
                sudo -E yum -y install python3
            elif has "apt-get"; then
                log_echo "Install python3 with Advanced Packaging Tool"
                sudo -E apt-get -y install python3
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

log_pass "python3: installed successfully"
