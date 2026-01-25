FROM debian:testing

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        bash-completion \
        ca-certificates \
        curl \
        git \
        htop \
        openssh-client \
        sudo \
        tmux \
        unzip \
        vim \
        zip \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash claude && \
    echo "claude ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/claude && \
    chmod 0440 /etc/sudoers.d/claude
    
COPY --chown=claude:claude config/ /home/claude/
COPY --chmod=755 scripts/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN mkdir -p /workspace && \
    chown -R claude:claude /workspace && \
    touch /home/claude/.bash_history && \
    mkdir -p /home/claude/.ssh && chmod 700 /home/claude/.ssh && \
    mkdir -p /home/claude/.claude && chmod 700 /home/claude/.claude && \
    chown -R claude:claude /home/claude

USER claude
WORKDIR /workspace

RUN curl -fsSL https://claude.ai/install.sh | bash

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
