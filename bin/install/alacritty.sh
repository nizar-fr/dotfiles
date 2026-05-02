#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
#  Alacritty Installer — Linux
# =============================================================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()    { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# --------------------------------------------------------------------------- #
# 1. Detect distro and install dependencies
# --------------------------------------------------------------------------- #
install_deps() {
    info "Detecting Linux distribution..."

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO="${ID:-unknown}"
        DISTRO_LIKE="${ID_LIKE:-}"
    else
        error "Cannot detect distribution (/etc/os-release not found)."
    fi

    info "Detected: $PRETTY_NAME"

    case "$DISTRO" in
        ubuntu|debian|linuxmint|pop)
            info "Installing dependencies via apt..."
            sudo apt update -qq
            sudo apt install -y cmake g++ pkg-config libfontconfig1-dev \
                libxcb-xfixes0-dev libxkbcommon-dev python3
            ;;
        arch|manjaro|endeavouros|garuda)
            info "Installing dependencies via pacman..."
            sudo pacman -Sy --noconfirm cmake freetype2 fontconfig pkg-config \
                make libxcb libxkbcommon python
            ;;
        fedora)
            info "Installing dependencies via dnf..."
            sudo dnf install -y cmake freetype-devel fontconfig-devel \
                libxcb-devel libxkbcommon-devel g++
            ;;
        centos|rhel)
            if [[ "${VERSION_ID%%.*}" -ge 8 ]]; then
                info "Installing dependencies via dnf (RHEL/CentOS 8+)..."
                sudo dnf install -y cmake freetype-devel fontconfig-devel \
                    libxcb-devel libxkbcommon-devel
                sudo dnf group install -y "Development Tools"
            else
                info "Installing dependencies via yum (RHEL/CentOS 7)..."
                sudo yum install -y cmake freetype-devel fontconfig-devel \
                    libxcb-devel libxkbcommon-devel xcb-util-devel
                sudo yum group install -y "Development Tools"
            fi
            ;;
        opensuse*|sles)
            info "Installing dependencies via zypper..."
            sudo zypper install -y cmake freetype-devel fontconfig-devel \
                libxcb-devel libxkbcommon-devel gcc-c++
            ;;
        void)
            info "Installing dependencies via xbps-install..."
            sudo xbps-install -Sy cmake freetype-devel expat-devel \
                fontconfig-devel libxcb-devel pkg-config python3
            ;;
        alpine)
            info "Installing dependencies via apk..."
            sudo apk add cmake pkgconf freetype-dev fontconfig-dev \
                python3 libxcb-dev
            ;;
        solus)
            info "Installing dependencies via eopkg..."
            sudo eopkg install -y fontconfig-devel
            ;;
        nixos)
            info "NixOS detected — launching nix-shell with dependencies..."
            nix-shell -A alacritty '<nixpkgs>' --run "$0"
            exit 0
            ;;
        gentoo)
            info "Installing dependencies via emerge..."
            sudo emerge --onlydeps x11-terms/alacritty
            ;;
        *)
            # Fallback: check ID_LIKE for debian/rhel/arch families
            if echo "$DISTRO_LIKE" | grep -qi "debian\|ubuntu"; then
                warn "Unknown distro, but it looks Debian-like. Trying apt..."
                sudo apt update -qq
                sudo apt install -y cmake g++ pkg-config libfontconfig1-dev \
                    libxcb-xfixes0-dev libxkbcommon-dev python3
            elif echo "$DISTRO_LIKE" | grep -qi "rhel\|fedora"; then
                warn "Unknown distro, but it looks Fedora-like. Trying dnf..."
                sudo dnf install -y cmake freetype-devel fontconfig-devel \
                    libxcb-devel libxkbcommon-devel g++
            elif echo "$DISTRO_LIKE" | grep -qi "arch"; then
                warn "Unknown distro, but it looks Arch-like. Trying pacman..."
                sudo pacman -Sy --noconfirm cmake freetype2 fontconfig \
                    pkg-config make libxcb libxkbcommon python
            else
                error "Unsupported distribution: $DISTRO. Please install dependencies manually."
            fi
            ;;
    esac
}

# --------------------------------------------------------------------------- #
# 2. Install Rust (rustup)
# --------------------------------------------------------------------------- #
install_rust() {
    if command -v rustup &>/dev/null; then
        info "rustup already installed. Updating..."
        rustup override set stable
        rustup update stable
    else
        info "Installing Rust via rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
        # shellcheck source=/dev/null
        source "$HOME/.cargo/env"
        rustup override set stable
        rustup update stable
    fi

    # Make sure cargo is in PATH for the rest of this script
    export PATH="$HOME/.cargo/bin:$PATH"
}

# --------------------------------------------------------------------------- #
# 3. Clone and build Alacritty
# --------------------------------------------------------------------------- #
build_alacritty() {
    WORK_DIR="$(mktemp -d)"
    info "Cloning Alacritty into $WORK_DIR..."
    git clone --depth=1 https://github.com/alacritty/alacritty.git "$WORK_DIR/alacritty"
    cd "$WORK_DIR/alacritty"

    info "Building Alacritty (release)..."
    cargo build --release
}

# --------------------------------------------------------------------------- #
# 4. Install binary, terminfo, desktop entry, and man pages
# --------------------------------------------------------------------------- #
post_install() {
    info "Installing binary to /usr/local/bin..."
    sudo cp target/release/alacritty /usr/local/bin/alacritty
    sudo chmod +x /usr/local/bin/alacritty

    info "Installing terminfo..."
    sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

    info "Installing desktop entry and icon..."
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database 2>/dev/null || true

    info "Installing man pages..."
    if command -v scdoc &>/dev/null && command -v gzip &>/dev/null; then
        sudo mkdir -p /usr/local/share/man/man1
        sudo mkdir -p /usr/local/share/man/man5
        scdoc < extra/man/alacritty.1.scd       | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz       > /dev/null
        scdoc < extra/man/alacritty-msg.1.scd   | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz   > /dev/null
        scdoc < extra/man/alacritty.5.scd       | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz       > /dev/null
        scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null
        info "Man pages installed."
    else
        warn "scdoc or gzip not found — skipping man page installation."
    fi

    info "Installing shell completions..."
    # Zsh
    if command -v zsh &>/dev/null; then
        ZSH_FUNC_DIR="${ZDOTDIR:-$HOME}/.zsh_functions"
        mkdir -p "$ZSH_FUNC_DIR"
        cp extra/completions/_alacritty "$ZSH_FUNC_DIR/_alacritty"
        if ! grep -q "fpath+=$ZSH_FUNC_DIR" "${ZDOTDIR:-$HOME}/.zshrc" 2>/dev/null; then
            echo "fpath+=$ZSH_FUNC_DIR" >> "${ZDOTDIR:-$HOME}/.zshrc"
        fi
        info "Zsh completions installed."
    fi
    # Bash
    if command -v bash &>/dev/null; then
        mkdir -p "$HOME/.bash_completion"
        cp extra/completions/alacritty.bash "$HOME/.bash_completion/alacritty"
        if ! grep -q "source ~/.bash_completion/alacritty" "$HOME/.bashrc" 2>/dev/null; then
            echo "source ~/.bash_completion/alacritty" >> "$HOME/.bashrc"
        fi
        info "Bash completions installed."
    fi
    # Fish
    if command -v fish &>/dev/null; then
        FISH_COMP_DIR="$(fish -c 'echo $fish_complete_path[1]' 2>/dev/null || true)"
        if [ -n "$FISH_COMP_DIR" ]; then
            mkdir -p "$FISH_COMP_DIR"
            cp extra/completions/alacritty.fish "$FISH_COMP_DIR/alacritty.fish"
            info "Fish completions installed."
        fi
    fi
}

# --------------------------------------------------------------------------- #
# Main
# --------------------------------------------------------------------------- #
main() {
    echo ""
    echo "  ╔══════════════════════════════════════╗"
    echo "  ║     Alacritty Installer — Linux      ║"
    echo "  ╚══════════════════════════════════════╝"
    echo ""

    # Sanity checks
    command -v git  &>/dev/null || error "git is required but not installed."
    command -v curl &>/dev/null || error "curl is required but not installed."
    command -v sudo &>/dev/null || error "sudo is required but not installed."

    install_deps
    install_rust
    build_alacritty
    post_install

    echo ""
    info "✅  Alacritty installed successfully!"
    info "    Run: alacritty"
    echo ""
}

main "$@"
