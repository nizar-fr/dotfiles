#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
#  Docker Engine Installer — Ubuntu
# =============================================================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }
step()  { echo -e "\n${CYAN}━━━ $* ${NC}"; }

# --------------------------------------------------------------------------- #
# Sanity checks
# --------------------------------------------------------------------------- #
check_ubuntu() {
    if [ ! -f /etc/os-release ]; then
        error "Cannot detect OS. This script only supports Ubuntu."
    fi
    . /etc/os-release
    if [[ "$ID" != "ubuntu" ]]; then
        error "This script only supports Ubuntu. Detected: $ID"
    fi

    UBUNTU_CODENAME="${UBUNTU_CODENAME:-$VERSION_CODENAME}"
    SUPPORTED=("questing" "noble" "jammy")
    SUPPORTED_FOUND=false
    for s in "${SUPPORTED[@]}"; do
        [[ "$UBUNTU_CODENAME" == "$s" ]] && SUPPORTED_FOUND=true && break
    done
    if ! $SUPPORTED_FOUND; then
        warn "Ubuntu codename '$UBUNTU_CODENAME' is not in the officially supported list (jammy, noble, questing)."
        warn "Installation will proceed but may not work as expected."
    fi

    info "Detected: $PRETTY_NAME (codename: $UBUNTU_CODENAME)"
}

check_arch() {
    ARCH="$(dpkg --print-architecture)"
    SUPPORTED_ARCH=("amd64" "armhf" "arm64" "s390x" "ppc64el")
    ARCH_OK=false
    for a in "${SUPPORTED_ARCH[@]}"; do
        [[ "$ARCH" == "$a" ]] && ARCH_OK=true && break
    done
    $ARCH_OK || error "Unsupported architecture: $ARCH"
    info "Architecture: $ARCH"
}

# --------------------------------------------------------------------------- #
# Step 1 — Remove conflicting packages
# --------------------------------------------------------------------------- #
remove_conflicts() {
    step "Removing conflicting packages (if any)"

    CONFLICTS=(docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc)
    TO_REMOVE=()
    for pkg in "${CONFLICTS[@]}"; do
        if dpkg -l "$pkg" &>/dev/null 2>&1; then
            TO_REMOVE+=("$pkg")
        fi
    done

    if [ ${#TO_REMOVE[@]} -gt 0 ]; then
        info "Removing: ${TO_REMOVE[*]}"
        sudo apt-get remove -y "${TO_REMOVE[@]}"
    else
        info "No conflicting packages found."
    fi
}

# --------------------------------------------------------------------------- #
# Step 2 — Set up Docker apt repository
# --------------------------------------------------------------------------- #
setup_repository() {
    step "Setting up Docker apt repository"

    sudo apt-get update -qq
    sudo apt-get install -y ca-certificates curl

    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${UBUNTU_CODENAME}
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

    sudo apt-get update -qq
    info "Docker repository configured."
}

# --------------------------------------------------------------------------- #
# Step 3 — Install Docker Engine
# --------------------------------------------------------------------------- #
install_docker() {
    step "Installing Docker Engine"

    if [[ -n "${DOCKER_VERSION:-}" ]]; then
        info "Installing specific version: $DOCKER_VERSION"
        sudo apt-get install -y \
            docker-ce="$DOCKER_VERSION" \
            docker-ce-cli="$DOCKER_VERSION" \
            containerd.io \
            docker-buildx-plugin \
            docker-compose-plugin
    else
        info "Installing latest stable version..."
        sudo apt-get install -y \
            docker-ce \
            docker-ce-cli \
            containerd.io \
            docker-buildx-plugin \
            docker-compose-plugin
    fi

    info "Docker Engine installed."
}

# --------------------------------------------------------------------------- #
# Step 4 — Start & enable service
# --------------------------------------------------------------------------- #
enable_service() {
    step "Enabling Docker service"

    if command -v systemctl &>/dev/null; then
        sudo systemctl enable docker
        sudo systemctl start docker
        info "Docker service enabled and started."
    else
        warn "systemctl not found. Please start Docker manually."
    fi
}

# --------------------------------------------------------------------------- #
# Step 5 — Optional: add current user to docker group (no-sudo docker)
# --------------------------------------------------------------------------- #
add_user_to_group() {
    if [[ "${ADD_USER:-true}" == "false" ]]; then
        return
    fi
    step "Adding $USER to the 'docker' group"
    sudo usermod -aG docker "$USER"
    info "User '$USER' added to 'docker' group."
    warn "You need to log out and back in (or run 'newgrp docker') for this to take effect."
}

# --------------------------------------------------------------------------- #
# Step 6 — Verify installation
# --------------------------------------------------------------------------- #
verify() {
    step "Verifying installation"
    sudo docker run --rm hello-world \
        && info "✅  Docker is working correctly!" \
        || warn "hello-world test failed. Check 'sudo systemctl status docker'."
}

# --------------------------------------------------------------------------- #
# Argument parsing
# --------------------------------------------------------------------------- #
SKIP_VERIFY=false
ADD_USER=true

usage() {
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "  -v, --version VERSION   Install a specific Docker CE version"
    echo "                          e.g. '5:29.2.1-1~ubuntu.24.04~noble'"
    echo "  --no-add-user           Skip adding current user to the docker group"
    echo "  --skip-verify           Skip running the hello-world test"
    echo "  -h, --help              Show this help"
    echo ""
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--version)    DOCKER_VERSION="$2"; shift 2 ;;
        --no-add-user)   ADD_USER=false; shift ;;
        --skip-verify)   SKIP_VERIFY=true; shift ;;
        -h|--help)       usage ;;
        *) warn "Unknown option: $1"; shift ;;
    esac
done

# --------------------------------------------------------------------------- #
# Main
# --------------------------------------------------------------------------- #
main() {
    echo ""
    echo "  ╔══════════════════════════════════════╗"
    echo "  ║    Docker Engine Installer — Ubuntu  ║"
    echo "  ╚══════════════════════════════════════╝"
    echo ""

    command -v sudo  &>/dev/null || error "sudo is required but not installed."
    command -v curl  &>/dev/null || error "curl is required but not installed."

    check_ubuntu
    check_arch
    remove_conflicts
    setup_repository
    install_docker
    enable_service
    [[ "$ADD_USER" == "true" ]] && add_user_to_group
    [[ "$SKIP_VERIFY" == "false" ]] && verify

    DOCKER_VER="$(sudo docker --version 2>/dev/null || echo 'unknown')"
    COMPOSE_VER="$(sudo docker compose version 2>/dev/null || echo 'unknown')"

    echo ""
    info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    info "  Docker Engine : $DOCKER_VER"
    info "  Docker Compose: $COMPOSE_VER"
    info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    info "  Run: docker run hello-world"
    echo ""
}

main "$@"
