#!/bin/bash

declare -A version_map

OS_NAME=""
MINT_VERSION=$(grep VERSION_ID /etc/os-release | cut -d '"' -f 2)

