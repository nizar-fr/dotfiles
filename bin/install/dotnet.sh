#!/bin/bash

# Declare associative arrays for .NET versions
declare -A dotnet_versions_mint=(
    ["21.3"]="8.0"
    ["20.3"]="6.0"
    ["19.3"]="2.1"
)

declare -A dotnet_versions_ubuntu=(
    ["22.04"]="8.0"
    ["20.04"]="6.0"
    ["18.04"]="2.1"
)

declare -A dotnet_versions_arch=(
    ["latest"]="6.0"  # Arch typically has the latest version available
)

# Get OS name and version from /etc/os-release
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    OS_NAME=$NAME
    OS_VERSION=$VERSION_ID
else
    echo "Unable to determine OS information."
    exit 1
fi

# Determine .NET version based on OS name and version
if [[ $OS_NAME == *"Linux Mint"* ]]; then
    DOTNET_VERSION=${dotnet_versions_mint[$OS_VERSION]}
elif [[ $OS_NAME == *"Ubuntu"* ]]; then
    DOTNET_VERSION=${dotnet_versions_ubuntu[$OS_VERSION]}
elif [[ $OS_NAME == *"Arch"* ]]; then
    DOTNET_VERSION=${dotnet_versions_arch["latest"]}
else
    echo "Unsupported OS: $OS_NAME"
    exit 1
fi

# Check if a .NET version was found
if [[ -z $DOTNET_VERSION ]]; then
    echo "No .NET version available for $OS_NAME $OS_VERSION."
else
    echo "Detected OS: $OS_NAME $OS_VERSION"
    echo "Corresponding .NET SDK Version: $DOTNET_VERSION"

    # Example command to install .NET SDK (uncomment to use)
    sudo apt-get update && sudo apt-get install -y dotnet-sdk-$DOTNET_VERSION && sudo apt-get install -y aspnetcore-runtime-$DOTNET_VERSION
fi
