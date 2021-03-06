FROM debian:stable
MAINTAINER "gustav@rnld.se"
# PRIVIOUS MAINTAINER "EEA: IDM2 A-Team" <eea-edw-a-team-alerts@googlegroups.com>

# ------------------------------------------------------------------------------
ENV HOME /root
# Install dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential git pylint virtualenv python3-dev python3-pip openssh-server \
    curl wget python3-setuptools gnupg zsh \
 && apt-get install -y --no-install-recommends nodejs \
 && ln -s /usr/bin/nodejs /usr/bin/node \
 && curl -sL https://deb.nodesource.com/setup | bash - \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && pip3 install chaperone \
 && mkdir /etc/chaperone.d /cloud9 /var/run/sshd

# Install Zsh
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
      && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
      && chsh -s /bin/zsh

# TMUX conf
RUN echo "set-option -g default-shell /bin/zsh" >> ~/.tmux.conf
RUN echo "set -g mode-mouse on" >> ~/.tmux.conf
#RUN echo "set -g default-command zsh" >> ~/.tmux.conf

# ------------------------------------------------------------------------------
# Get cloud9 source and install
WORKDIR /cloud9
RUN git clone https://github.com/c9/core.git . \
 && scripts/install-sdk.sh \
 && sed -i -e 's_127.0.0.1_0.0.0.0_g' configs/standalone.js \
 && sed -i -e 's_message: "-d all -e E -e F",_message: "-d all -e E,F,W",_g' plugins/c9.ide.language.python/python.js \
 && mkdir workspace

# ------------------------------------------------------------------------------
# Add workspace volumes
VOLUME /cloud9/workspace

# ------------------------------------------------------------------------------
# Set default workspace dir
ENV C9_WORKSPACE /cloud9/workspace
#ENV AUTHORIZED_KEYS **None**

# ------------------------------------------------------------------------------
# Configuration
COPY conf/chaperone.conf /etc/chaperone.d/chaperone.conf
ADD sshd.sh /sshd.sh

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 8080 22 5000 8888 8889 8890

# ------------------------------------------------------------------------------
# Start
ENV SHELL /bin/zsh
ENTRYPOINT ["/usr/local/bin/chaperone"]
