FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 

RUN apt-get -qy install software-properties-common
# Neovim
RUN add-apt-repository ppa:neovim-ppa/stable
RUN apt-get install -y neovim
#Golang 
RUN add-apt-repository ppa:longsleep/golang-backports
RUN apt-get -qy install golang-go


# Install gcc
RUN apt-get -y install gcc mono-mcs && \
    rm -rf /var/lib/apt/lists/*
# Install python packages

RUN apt-get update

RUN apt-get install -y python3.6 && \
  apt-get install -y python3.6-dev

RUN apt-get install -y build-essential python3.6 python3.6-dev python3-pip python3.6-venv
RUN pip3 install --user ipython


## Default Packages
RUN apt -qy install ruby2.5 ruby2.5-dev
#RUN apt-get install -y -q ruby1.9.1 ruby1.9.1-dev build-essential 
RUN apt-get install -y nano wget links curl rsync bc git git-core apt-transport-https libxml2 libxml2-dev libcurl4-openssl-dev openssl sqlite3 libsqlite3-dev

#install ipython and nginx
RUN apt-get install -y gawk libreadline6-dev libyaml-dev autoconf libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
RUN apt-get -qy install ipython ipython3
RUN apt-get -qy install python-virtualenv virtualenv
RUN pip3 install --user ipython 
RUN apt-get -qy install nginx-extras
#RUN apt-get install python-virtualenv virtualenv 
#Ruby
RUN apt-get -qy install gnupg2
RUN apt-get -qy install make  
###
RUN gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io -o rvm.sh
RUN cat /rvm.sh | bash -s stable --rails

# Fish
RUN apt-get install -y fish

#PHP 
RUN apt-get install -y php7.2
RUN apt-get install -y php-pear php7.2-curl php7.2-dev php7.2-gd php7.2-mbstring php7.2-zip php7.2-mysql php7.2-xml

#RUST
RUN apt-get install -y cargo

#Git
RUN apt-get install -y git
RUN apt-get install -y gnupg
RUN apt-get install -y gnupg2


# Install java JDK
RUN apt-get -qy install default-jdk
RUN java -version
# Intsall Nodejs with NVM

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get install -y curl \
    && apt-get -y autoclean

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 4.4.7

RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN node -v
RUN npm -v
# Install Dracut

RUN apt-get -qy install dracut

# Intsall SQL


ENV MYSQL_USER=mysql \
    MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_RUN_DIR=/run/mysqld \
    MYSQL_LOG_DIR=/var/log/mysql

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server\
 && rm -rf ${MYSQL_DATA_DIR} \
 && rm -rf /var/lib/apt/lists/*

 RUN apt-get -y install gcc mono-mcs && \
    rm -rf /var/lib/apt/lists/*
# Install python packages
RUN apt-get install -y python3.6 && \
  apt-get install -y python3.6-dev

RUN apt-get install -y build-essential python3.6 python3.6-dev python3-pip python3.6-venv
RUN apt-get install -y git

# update pip
RUN python3.6 -m pip install pip --upgrade
RUN python3.6 -m pip install wheel

RUN pip install numpy scipy pandas matplotlib

#install perl
RUN apt-get install -y perl



RUN apt-get update && apt-get install -y \
      curl \
      dbus \
      kmod \
      iproute2 \
      iputils-ping \
      net-tools \
      openssh-server \
      sudo \
      systemd \
      udev \
      vim-tiny \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create the following files, but unset them
RUN echo "" > /etc/machine-id && echo "" > /var/lib/dbus/machine-id

# This container image doesn't have locales installed. Disable forwarding the
# user locale env variables or we get warnings such as:
#  bash: warning: setlocale: LC_ALL: cannot change locale
RUN sed -i -e 's/^AcceptEnv LANG LC_\*$/#AcceptEnv LANG LC_*/' /etc/ssh/sshd_config

# Set the root password to root when logging in through the VM's ttyS0 console
RUN echo "root:root" | chpasswd
