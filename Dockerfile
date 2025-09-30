# Use Ubuntu as base image (Ubuntu 22.04 LTS for Yocto compatibility)
FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /yocto

# Install ALL required packages for Yocto build, testing, and documentation
RUN apt-get update && apt-get install -y \
    # Core Yocto build requirements (official list from Yocto docs)
    build-essential \
    chrpath \
    cpio \
    debianutils \
    diffstat \
    file \
    gawk \
    gcc \
    git \
    iputils-ping \
    libacl1 \
    liblz4-tool \
    locales \
    python3 \
    python3-git \
    python3-jinja2 \
    python3-pexpect \
    python3-pip \
    python3-subunit \
    socat \
    texinfo \
    unzip \
    wget \
    xz-utils \
    zstd \
    # Additional useful packages for development
    gcc-multilib \
    libegl1-mesa \
    libsdl1.2-dev \
    xterm \
    mesa-common-dev \
    sudo \
    vim \
    # Documentation build packages (from Yocto docs)
    librsvg2-bin \
    make \
    python3-saneyaml \
    python3-sphinx-rtd-theme \
    sphinx \
    # PDF documentation packages (optional)
    fonts-freefont-otf \
    latexmk \
    tex-gyre \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-lang-all \
    texlive-latex-extra \
    texlive-latex-recommended \
    texlive-xetex \
    # CRITICAL: Required for ./full-test.sh automation
    sshpass \
    # Highly Recommended: Host QEMU for flexibility and troubleshooting
    qemu-system-x86 \
    qemu-utils \
    # Network tools for socket testing
    netcat-openbsd \
    curl \
    # SSH client for git operations
    openssh-client \
    # Useful: For SSL development headers
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set up en_US.UTF-8 locale (required by Yocto)
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Create a non-root user for Yocto builds (recommended practice)
RUN useradd -m -s /bin/bash yocto && \
    usermod -aG sudo yocto && \
    echo "yocto ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the yocto user
USER yocto
WORKDIR /home/yocto

# Set Git configuration (replace with your details if needed)
RUN git config --global user.name "Yocto Builder" && \
    git config --global user.email "yocto@builder.com"

# Create workspace directory
RUN mkdir -p /home/yocto/yocto-workspace

WORKDIR /home/yocto/yocto-workspace

# Default command
CMD ["/bin/bash"]
