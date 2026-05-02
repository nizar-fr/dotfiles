#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
#  Neovim Installer — Linux
# =============================================================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }
step()  { echo -e "\n${CYAN}━━━ $* ${NC}"; }

# --------------------------------------------------------------------------- #
# Helpers
# --------------------------------------------------------------------------- #
detect_arch() {
    ARCH="$(uname -m)"
    case "$ARCH" in
        x86_64)  ARCH_LABEL="x86_64" ;;
        aarch64) ARCH_LABEL="arm64"  ;;
        *) error "Unsupported architecture: $ARCH" ;;
    esac
}

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO="${ID:-unknown}"
        DISTRO_LIKE="${ID_LIKE:-}"
        DISTRO_VERSION="${VERSION_ID:-0}"
    else
        error "Cannot detect distribution (/etc/os-release not found)."
    fi
    info "Detected: ${PRETTY_NAME:-$DISTRO}"
}

is_debian_like() {
    [[ "$DISTRO" =~ ^(ubuntu|debian|linuxmint|pop|kali|raspbian)$ ]] \
        || echo "$DISTRO_LIKE" | grep -qi "debian\|ubuntu"
}

is_fedora_like() {
    [[ "$DISTRO" =~ ^(fedora|rhel|centos|rocky|almalinux)$ ]] \
        || echo "$DISTRO_LIKE" | grep -qi "rhel\|fedora"
}

is_arch_like() {
    [[ "$DISTRO" =~ ^(arch|manjaro|endeavouros|garuda|artix)$ ]] \
        || echo "$DISTRO_LIKE" | grep -qi "arch"
}

# --------------------------------------------------------------------------- #
# Installation methods
# --------------------------------------------------------------------------- #

# Method 1: distro package manager (stable, easiest)
install_via_package_manager() {
    step "Installing Neovim via package manager"

    if is_arch_like; then
        sudo pacman -Sy --noconfirm neovim python-pynvim

    elif is_debian_like; then
        sudo apt-get update -qq
        sudo apt-get install -y neovim python3-neovim

    elif [[ "$DISTRO" == "fedora" ]]; then
        sudo dnf install -y neovim python3-neovim

    elif [[ "$DISTRO" =~ ^(centos|rhel|rocky|almalinux)$ ]]; then
        # EPEL required for RHEL/CentOS 8+
        sudo yum install -y "https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm" 2>/dev/null || true
        sudo yum install -y neovim python3-neovim

    elif [[ "$DISTRO" =~ ^(opensuse|sles)$ ]] || echo "$DISTRO_LIKE" | grep -qi "suse"; then
        sudo zypper in -y neovim python-neovim python3-neovim

    elif [[ "$DISTRO" == "void" ]]; then
        sudo xbps-install -Sy neovim

    elif [[ "$DISTRO" == "alpine" ]]; then
        sudo apk add neovim

    elif [[ "$DISTRO" == "solus" ]]; then
        sudo eopkg install -y neovim

    elif [[ "$DISTRO" == "gentoo" ]]; then
        sudo emerge -a app-editors/neovim

    elif [[ "$DISTRO" =~ ^(nixos|nix)$ ]]; then
        nix-env -iA nixpkgs.neovim

    elif [[ "$DISTRO" == "clearlinux" ]] || [[ "$DISTRO" == "clear-linux-os" ]]; then
        sudo swupd bundle-add neovim python-basic

    elif [[ "$DISTRO" == "mageia" ]]; then
        sudo urpmi neovim python3-pynvim

    else
        # Fallback guesses
        if is_debian_like; then
            sudo apt-get update -qq && sudo apt-get install -y neovim
        elif is_fedora_like; then
            sudo dnf install -y neovim || sudo yum install -y neovim
        elif is_arch_like; then
            sudo pacman -Sy --noconfirm neovim
        else
            return 1  # signal: try another method
        fi
    fi

    info "Neovim installed via package manager."
}

# Method 2: pre-built tarball from GitHub releases (always latest stable)
install_via_tarball() {
    step "Installing Neovim via pre-built tarball (latest stable)"
    detect_arch

    TARBALL="nvim-linux-${ARCH_LABEL}.tar.gz"
    URL="https://github.com/neovim/neovim/releases/latest/download/${TARBALL}"

    info "Downloading $URL ..."
    curl -LO "$URL"

    sudo rm -rf "/opt/nvim-linux-${ARCH_LABEL}"
    sudo tar -C /opt -xzf "$TARBALL"
    rm -f "$TARBALL"

    # Symlink so nvim is in PATH immediately without editing shell config
    sudo ln -sf "/opt/nvim-linux-${ARCH_LABEL}/bin/nvim" /usr/local/bin/nvim

    info "Neovim installed to /opt/nvim-linux-${ARCH_LABEL}"
    info "Binary symlinked at /usr/local/bin/nvim"
}

# Method 3: snap (universal fallback)
install_via_snap() {
    step "Installing Neovim via snap"
    if ! command -v snap &>/dev/null; then
        error "snap not available. Cannot fall back to snap installation."
    fi
    sudo snap install nvim --classic
    info "Neovim installed via snap."
}

# --------------------------------------------------------------------------- #
# Argument parsing
# --------------------------------------------------------------------------- #
METHOD="auto"
CHANNEL="stable"   # stable | nightly

usage() {
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "  -m, --method   Installation method: auto | pkg | tarball | snap"
    echo "                 Default: auto (tries pkg first, then tarball)"
    echo "  -c, --channel  Release channel: stable | nightly"
    echo "                 Default: stable (only affects tarball method)"
    echo "  -h, --help     Show this help message"
    echo ""
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -m|--method)  METHOD="$2"; shift 2 ;;
        -c|--channel) CHANNEL="$2"; shift 2 ;;
        -h|--help)    usage ;;
        *) warn "Unknown option: $1"; shift ;;
    esac
done

# --------------------------------------------------------------------------- #
# Main
# --------------------------------------------------------------------------- #
main() {
    echo ""
    echo "  ╔══════════════════════════════════════╗"
    echo "  ║      Neovim Installer — Linux        ║"
    echo "  ╚══════════════════════════════════════╝"
    echo ""

    command -v sudo &>/dev/null || error "sudo is required but not installed."
    command -v curl &>/dev/null || error "curl is required but not installed."

    detect_distro

    case "$METHOD" in
        auto)
            if install_via_package_manager; then
                : # success
            else
                warn "Package manager install failed or unsupported. Falling back to tarball."
                install_via_tarball
            fi
            ;;
        pkg)      install_via_package_manager ;;
        tarball)  install_via_tarball ;;
        snap)     install_via_snap ;;
        *) error "Unknown method: $METHOD. Choose: auto | pkg | tarball | snap" ;;
    esac

    # Handle nightly tarball override
    if [[ "$CHANNEL" == "nightly" && "$METHOD" == "tarball" ]]; then
        detect_arch
        TARBALL="nvim-linux-${ARCH_LABEL}.tar.gz"
        NIGHTLY_URL="https://github.com/neovim/neovim/releases/download/nightly/${TARBALL}"
        info "Downloading nightly build..."
        curl -LO "$NIGHTLY_URL"
        sudo rm -rf "/opt/nvim-linux-${ARCH_LABEL}"
        sudo tar -C /opt -xzf "$TARBALL"
        rm -f "$TARBALL"
        sudo ln -sf "/opt/nvim-linux-${ARCH_LABEL}/bin/nvim" /usr/local/bin/nvim
    fi

    # Verify
    if command -v nvim &>/dev/null; then
        NVIM_VERSION="$(nvim --version | head -n1)"
        echo ""
        info "✅  Neovim installed successfully!"
        info "    Version: $NVIM_VERSION"
        info "    Run: nvim"
        echo ""
    else
        warn "nvim not found in PATH after install."
        warn "You may need to add /usr/local/bin or /opt/nvim-linux-${ARCH_LABEL:-x86_64}/bin to your PATH."
    fi
}

main "$@"
