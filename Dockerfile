FROM node:25-trixie
USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV CLAUDE_CONFIG_DIR=/home/claude/.claude

RUN apt-get update && \
    apt-get install -y \
        bash-completion \
        htop \
        locales \
        sudo \
        tmux \
        unzip \
        vim \
        zip \
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN useradd -m -s /bin/bash claude && \
    echo "claude ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/claude && \
    chmod 0440 /etc/sudoers.d/claude
    
COPY --chown=claude:claude config/ /home/claude/
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod 755 /usr/local/bin/entrypoint.sh && \
    mkdir -p /workspace && \
    chown -R claude:claude /workspace && \
    mkdir -p /home/claude/.bash.d && \
    mkdir -p /home/claude/.ssh && chmod 700 /home/claude/.ssh && \
    mkdir -p /home/claude/.claude && chmod 700 /home/claude/.claude && \
    echo 'for f in ~/.bashrc.d/*.bash; do [ -r "$f" ] && . "$f"; done' >> /home/claude/.bashrc && \
    chown -R claude:claude /home/claude

USER claude
WORKDIR /workspace

RUN npm install -g @beads/bd
RUN curl -fsSL https://claude.ai/install.sh | bash

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
