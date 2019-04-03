FROM daimor/intersystems-iris:2019.1.0S.111.0-community

### base ###
RUN yes | unminimize \
    && apt-get install -yq \
        asciidoctor \
        bash-completion \
        build-essential \
        htop \
        jq \
        less \
        llvm \
        locales \
        man-db \
        nano \
        software-properties-common \
        sudo \
        vim \
    && locale-gen en_US.UTF-8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*
ENV LANG=en_US.UTF-8

### Gitpod user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 33333 -G sudo,irisusr,root -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
ENV HOME=/home/gitpod
WORKDIR $HOME
# custom Bash prompt
RUN { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> .bashrc

USER gitpod 

ENV IRIS_USER=gitpod \
    IRIS_PASSWORD=gitpod

USER root

RUN chown -R gitpod /usr/local/etc/irissys \
 && chown -R gitpod /usr/irissys

ENTRYPOINT [ "/bin/bash" ]