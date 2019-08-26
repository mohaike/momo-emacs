#!/bin/sh

export PATH=/usr/local/bin:$PATH
gem_reInstall()
{
    tool_name="${1}"
    echo
    echo "reinstall ${tool_name}"
    echo
    gem uninstall "${tool_name}"
    sudo rm $(which ${tool_name})
    sudo gem install -n /usr/local/bin ${tool_name}
}

gem_reInstall fastlane
