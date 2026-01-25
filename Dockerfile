FROM debian:testing

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        bash-completion \
        build-essential \
        ca-certificates \
        curl \
        git \
        gzip \
        htop \
        iputils-ping \
        jq \
        less \
        locales \
        net-tools \
        openssh-client \
        procps \
        strace \
        sudo \
        tar \
        tmux \
        tree \
        tzdata \
        unzip \
        vim \
        wget \
        zip \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=UTC

RUN useradd -m -s /bin/bash claude && \
    echo "claude ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/claude && \
    chmod 0440 /etc/sudoers.d/claude

RUN mkdir -p /workspace && \
    chown -R claude:claude /workspace

USER claude
WORKDIR /workspace

RUN curl -fsSL https://claude.ai/install.sh | bash

CMD ["/bin/bash"]