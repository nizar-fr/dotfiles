#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
#  Unity Hub Installer — Linux (Ubuntu/Debian & RHEL/CentOS)
# =============================================================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }
step()  { echo -e "\n${CYAN}━━━ $* ${NC}"; }

# --------------------------------------------------------------------------- #
# Defaults
# --------------------------------------------------------------------------- #
CHANNEL="stable"      # stable | beta
BETA_VERSION=""       # e.g. "3.4.1-beta.1" (only used when CHANNEL=beta on apt)

# --------------------------------------------------------------------------- #
# Distro detection
# --------------------------------------------------------------------------- #
detect_distro() {
    [ -f /etc/os-release ] || error "Cannot detect OS (/etc/os-release not found)."
    . /etc/os-release
    DISTRO="${ID:-unknown}"
    DISTRO_LIKE="${ID_LIKE:-}"
    info "Detected: ${PRETTY_NAME:-$DISTRO}"
}

is_apt_based() {
    [[ "$DISTRO" =~ ^(ubuntu|debian|raspbian|linuxmint|pop)$ ]] \
        || echo "$DISTRO_LIKE" | grep -qi "debian\|ubuntu"
}

is_rpm_based() {
    [[ "$DISTRO" =~ ^(centos|rhel|rocky|almalinux|fedora)$ ]] \
        || echo "$DISTRO_LIKE" | grep -qi "rhel\|fedora"
}

# --------------------------------------------------------------------------- #
# apt-based install (Ubuntu / Debian)
# --------------------------------------------------------------------------- #
install_apt() {
    step "Setting up Unity Hub repository (apt)"

    # Dependency
    if ! command -v curl &>/dev/null; then
        info "Installing curl..."
        sudo apt-get update -qq
        sudo apt-get install -y curl
    fi

    # GPG keyring
    sudo install -d /etc/apt/keyrings
    curl -fsSL https://hub.unity3d.com/linux/keys/public \
        | sudo gpg --dearmor -o /etc/apt/keyrings/unityhub.gpg
    sudo chmod go+r /etc/apt/keyrings/unityhub.gpg
    info "GPG key installed."

    # Stable repository
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/unityhub.gpg] \
https://hub.unity3d.com/linux/repos/deb stable main" \
        | sudo tee /etc/apt/sources.list.d/unityhub.list > /dev/null
    info "Stable repository added."

    # Beta repository (optional)
    if [[ "$CHANNEL" == "beta" ]]; then
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/unityhub.gpg] \
https://hub.unity3d.com/linux/repos/deb unstable main" \
            | sudo tee /etc/apt/sources.list.d/unityhub-beta.list > /dev/null
        info "Beta repository added."
    fi

    sudo apt-get update -qq

    step "Installing Unity Hub"
    if [[ "$CHANNEL" == "beta" && -n "$BETA_VERSION" ]]; then
        info "Installing beta version: $BETA_VERSION"
        sudo apt-get install -y "unityhub=${BETA_VERSION}"
    else
        sudo apt-get install -y unityhub
    fi
}

# --------------------------------------------------------------------------- #
# RPM-based install (RHEL / CentOS)
# --------------------------------------------------------------------------- #
install_rpm() {
    step "Setting up Unity Hub repository (yum/dnf)"

    warn "Note: Unity Hub does not officially support RHEL/CentOS, but installation is possible."

    if [[ "$CHANNEL" == "beta" ]]; then
        REPO_URL="https://hub.unity3d.com/linux/repos/rpm/unstable"
        REPO_NAME="unityhub-beta"
        REPO_LABEL="Unity Hub Beta"
    else
        REPO_URL="https://hub.unity3d.com/linux/repos/rpm/stable"
        REPO_NAME="unityhub"
        REPO_LABEL="Unity Hub"
    fi

    sudo sh -c "cat > /etc/yum.repos.d/${REPO_NAME}.repo" <<EOF
[${REPO_NAME}]
name=${REPO_LABEL}
baseurl=${REPO_URL}
enabled=1
gpgcheck=1
gpgkey=${REPO_URL}/repodata/repomd.xml.key
repo_gpgcheck=1
EOF
    info "Repository file created: /etc/yum.repos.d/${REPO_NAME}.repo"

    step "Installing Unity Hub"
    if command -v dnf &>/dev/null; then
        sudo dnf install -y unityhub
    else
        sudo yum install -y unityhub
    fi
}

# --------------------------------------------------------------------------- #
# Argument parsing
# --------------------------------------------------------------------------- #
usage() {
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "  -c, --channel  Release channel: stable | beta  (default: stable)"
    echo "  -b, --beta-version VERSION"
    echo "                 Specific beta version to install on apt-based systems"
    echo "                 e.g. '3.4.1-beta.1' (only applies when --channel beta)"
    echo "  -h, --help     Show this help"
    echo ""
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -c|--channel)       CHANNEL="$2"; shift 2 ;;
        -b|--beta-version)  BETA_VERSION="$2"; shift 2 ;;
        -h|--help)          usage ;;
        *) warn "Unknown option: $1"; shift ;;
    esac
done

[[ "$CHANNEL" =~ ^(stable|beta)$ ]] || error "Invalid channel: '$CHANNEL'. Use 'stable' or 'beta'."

# --------------------------------------------------------------------------- #
# Main
# --------------------------------------------------------------------------- #
main() {
    echo ""
    echo "  ╔══════════════════════════════════════╗"
    echo "  ║     Unity Hub Installer — Linux      ║"
    echo "  ╚══════════════════════════════════════╝"
    echo ""

    command -v sudo &>/dev/null || error "sudo is required but not installed."

    detect_distro

    # Architecture check for apt path (deb repo is amd64 only)
    if is_apt_based; then
        ARCH="$(dpkg --print-architecture 2>/dev/null || uname -m)"
        if [[ "$ARCH" != "amd64" && "$ARCH" != "x86_64" ]]; then
            error "The Unity Hub apt repository only supports amd64/x86_64. Detected: $ARCH"
        fi
        install_apt
    elif is_rpm_based; then
        install_rpm
    else
        error "Unsupported distribution: $DISTRO. Unity Hub only officially supports Ubuntu/Debian and RHEL/CentOS."
    fi

    # Verify
    if command -v unityhub &>/dev/null; then
        echo ""
        info "✅  Unity Hub installed successfully!"
        info "    Run: unityhub"
    else
        # AppImage / desktop launcher may not put it in PATH
        echo ""
        info "✅  Unity Hub installed."
        warn "    'unityhub' may not be in PATH — launch it from your application menu"
        warn "    or run: /opt/unityhub/unityhub"
    fi

    echo ""
    info "    To update in the future:"
    if is_apt_based; then
        info "      sudo apt update && sudo apt install unityhub"
    else
        info "      sudo yum update unityhub  (or: sudo dnf update unityhub)"
    fi
    echo ""
}

main "$@"
