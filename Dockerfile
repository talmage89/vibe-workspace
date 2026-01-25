FROM debian:testing

RUN apt-get update && \
    apt-get install -y \
        curl \
        git \
        ca-certificates \
        build-essential \
        wget \
        vim \
        less \
        procps \
        unzip \
        zip \
        tar \
        gzip \
        locales \
        tzdata \
        sudo \
        jq \
        bash-completion \
        tree \
        htop \
        strace \
        net-tools \
        iputils-ping \
        openssh-client \
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

COPY config/bashrc /home/claude/.bashrc
RUN chown claude:claude /home/claude/.bashrc

USER claude
WORKDIR /workspace

RUN curl -fsSL https://claude.ai/install.sh | bash

CMD ["/bin/bash"]