#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
#  GitHub CLI (gh) Installer — Linux
# =============================================================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }
step()  { echo -e "\n${CYAN}━━━ $* ${NC}"; }

# --------------------------------------------------------------------------- #
# Distro detection
# --------------------------------------------------------------------------- #
detect_distro() {
    if [ ! -f /etc/os-release ]; then
        error "Cannot detect distribution (/etc/os-release not found)."
    fi
    . /etc/os-release
    DISTRO="${ID:-unknown}"
    DISTRO_LIKE="${ID_LIKE:-}"
    info "Detected: ${PRETTY_NAME:-$DISTRO}"
}

is_apt_based() {
    [[ "$DISTRO" =~ ^(ubuntu|debian|raspbian|linuxmint|pop|kali)$ ]] \
        || echo "$DISTRO_LIKE" | grep -qi "debian\|ubuntu"
}

is_dnf_based() {
    [[ "$DISTRO" =~ ^(fedora|centos|rhel|rocky|almalinux)$ ]] \
        || echo "$DISTRO_LIKE" | grep -qi "rhel\|fedora"
}

is_suse_based() {
    [[ "$DISTRO" =~ ^(opensuse.*|sles)$ ]] \
        || echo "$DISTRO_LIKE" | grep -qi "suse"
}

# --------------------------------------------------------------------------- #
# Installation methods
# --------------------------------------------------------------------------- #

install_apt() {
    step "Installing gh via apt (Debian/Ubuntu/Raspberry Pi OS)"
    sudo apt-get update -qq
    sudo apt-get install -y wget

    sudo mkdir -p -m 755 /etc/apt/keyrings
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] \
https://cli.github.com/packages stable main" \
        | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

    sudo apt-get update -qq
    sudo apt-get install -y gh
}

install_dnf() {
    step "Installing gh via dnf (Fedora/CentOS/RHEL)"
    sudo dnf install -y 'dnf-command(config-manager)'
    sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
    sudo dnf install -y gh --repo gh-cli
}

install_yum() {
    step "Installing gh via yum (Amazon Linux 2 / CentOS 7)"
    # Install yum-utils if yum-config-manager is missing
    if ! command -v yum-config-manager &>/dev/null; then
        sudo yum install -y yum-utils
    fi
    sudo yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
    sudo yum install -y gh
}

install_zypper() {
    step "Installing gh via zypper (openSUSE/SUSE)"
    sudo zypper addrepo https://cli.github.com/packages/rpm/gh-cli.repo || true
    sudo zypper ref
    sudo zypper install -y gh
}

install_pacman() {
    step "Installing gh via pacman (Arch Linux)"
    sudo pacman -Sy --noconfirm github-cli
}

install_alpine() {
    step "Installing gh via apk (Alpine Linux)"
    sudo apk add github-cli
}

install_void() {
    step "Installing gh via xbps-install (Void Linux)"
    sudo xbps-install -Sy github-cli
}

install_nix() {
    step "Installing gh via nix (NixOS)"
    nix-env -iA nixos.gh
}

install_gentoo() {
    step "Installing gh via emerge (Gentoo)"
    sudo emerge -av dev-util/github-cli
}

install_funtoo() {
    step "Installing gh via emerge (Funtoo)"
    sudo emerge -av github-cli
}

install_binary() {
    step "Installing gh via pre-built binary (fallback)"

    ARCH="$(uname -m)"
    case "$ARCH" in
        x86_64)  GH_ARCH="amd64" ;;
        aarch64) GH_ARCH="arm64" ;;
        armv7l)  GH_ARCH="armhf" ;;
        i686)    GH_ARCH="386"   ;;
        *) error "Unsupported architecture for binary install: $ARCH" ;;
    esac

    info "Fetching latest release tag..."
    LATEST="$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest \
        | grep '"tag_name"' | head -1 | cut -d'"' -f4)"
    VERSION="${LATEST#v}"

    TARBALL="gh_${VERSION}_linux_${GH_ARCH}.tar.gz"
    URL="https://github.com/cli/cli/releases/download/${LATEST}/${TARBALL}"

    info "Downloading $URL ..."
    curl -LO "$URL"
    tar -xzf "$TARBALL"
    sudo install -m 755 "gh_${VERSION}_linux_${GH_ARCH}/bin/gh" /usr/local/bin/gh
    rm -rf "$TARBALL" "gh_${VERSION}_linux_${GH_ARCH}"

    info "gh binary installed to /usr/local/bin/gh"
}

# --------------------------------------------------------------------------- #
# Main router
# --------------------------------------------------------------------------- #
install_gh() {
    detect_distro

    case "$DISTRO" in
        ubuntu|debian|raspbian|linuxmint|pop|kali)
            install_apt ;;
        fedora)
            install_dnf ;;
        centos|rhel|rocky|almalinux)
            # CentOS/RHEL 8+ have dnf; 7 uses yum
            if command -v dnf &>/dev/null; then
                install_dnf
            else
                install_yum
            fi
            ;;
        amzn)
            install_yum ;;
        opensuse*|sles)
            install_zypper ;;
        arch|manjaro|endeavouros|garuda|artix)
            install_pacman ;;
        alpine)
            install_alpine ;;
        void)
            install_void ;;
        nixos)
            install_nix ;;
        gentoo)
            install_gentoo ;;
        funtoo)
            install_funtoo ;;
        *)
            # Fallback via ID_LIKE
            if is_apt_based; then
                warn "Unknown distro, but looks apt-based. Trying apt method..."
                install_apt
            elif is_dnf_based; then
                warn "Unknown distro, but looks dnf-based. Trying dnf method..."
                install_dnf
            elif is_suse_based; then
                warn "Unknown distro, but looks SUSE-based. Trying zypper method..."
                install_zypper
            else
                warn "Could not match distro '$DISTRO' to a known package manager."
                warn "Falling back to pre-built binary install..."
                install_binary
            fi
            ;;
    esac
}

# --------------------------------------------------------------------------- #
# Post-install: optional auth
# --------------------------------------------------------------------------- #
prompt_auth() {
    echo ""
    read -r -p "  Would you like to authenticate with GitHub now? [y/N] " yn
    case "$yn" in
        [yY]*) gh auth login ;;
        *)     info "Skipping auth. Run 'gh auth login' whenever you're ready." ;;
    esac
}

# --------------------------------------------------------------------------- #
# Main
# --------------------------------------------------------------------------- #
main() {
    echo ""
    echo "  ╔══════════════════════════════════════╗"
    echo "  ║    GitHub CLI (gh) Installer         ║"
    echo "  ╚══════════════════════════════════════╝"
    echo ""

    command -v curl  &>/dev/null || error "curl is required but not installed."
    command -v sudo  &>/dev/null || error "sudo is required but not installed."

    install_gh

    # Verify
    if command -v gh &>/dev/null; then
        GH_VERSION="$(gh --version | head -n1)"
        echo ""
        info "✅  GitHub CLI installed successfully!"
        info "    $GH_VERSION"
        prompt_auth
    else
        warn "gh not found in PATH after install. You may need to restart your shell."
    fi

    echo ""
}

main "$@"
