FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
########################################################## NeoVim #########################################################
RUN apt-get -qy install software-properties-common \
    && add-apt-repository ppa:neovim-ppa/stable \
    && apt-get install -y neovim

########################################################### Golang ######################################################## 
RUN add-apt-repository ppa:longsleep/golang-backports \
    && apt-get -qy install golang-go


######################################################### Install gcc #####################################################
RUN apt-get -y install gcc mono-mcs && \
    rm -rf /var/lib/apt/lists/* \
    && Install python packages

######################################################## Python ###########################################################
RUN apt-get update \
    && apt-get install -y python3.6 && \
    apt-get install -y python3.6-dev \
    && apt-get install -y build-essential python3.6 python3.6-dev python3-pip python3.6-venv \
    && pip3 install --user ipython


#################################################### Default Packages #####################################################
RUN apt -qy install ruby2.5 ruby2.5-dev\ 
    && apt-get install -y nano wget links curl rsync bc git git-core apt-transport-https libxml2 libxml2-dev libcurl4-openssl-dev openssl sqlite3 libsqlite3-dev

################################################### install ipython and nginx #############################################
RUN apt-get install -y gawk libreadline6-dev libyaml-dev autoconf libgdbm-dev libncurses5-dev automake libtool bison libffi-dev \
    && apt-get -qy install ipython ipython3 \
    && apt-get -qy install python-virtualenv virtualenv\
    && pip3 install --user ipython \
    && apt-get -qy install nginx-extras \
    && apt-get -qy install gnupg2 \
    && apt-get -qy install make  

###########################################################################################################################
RUN gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
&& curl -sSL https://get.rvm.io -o rvm.sh \
&& cat /rvm.sh | bash -s stable --rails

############################################################ Fish Shell ###################################################
RUN apt-get install -y fish \
    && apt-get install -y php7.2   ### PHP\
    && apt-get install -y php-pear php7.2-curl php7.2-dev php7.2-gd php7.2-mbstring php7.2-zip php7.2-mysql php7.2-xml

############################################################## RUST #######################################################
RUN apt-get install -y cargo \
    && apt-get install -y git \
    && apt-get install -y gnupg \
    && apt-get install -y gnupg2 


######################################################### Install java JDK ################################################
RUN apt-get -qy install default-jdk \
    && java -version

####################################################### Install Nodejs with NVM############################################

RUN rm /bin/sh && ln -s /bin/bash /bin/sh \
    && apt-get install -y curl \
    && apt-get -y autoclean \
    && ENV NVM_DIR /usr/local/nvm \
    && ENV NODE_VERSION 4.4.7

RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules \
    && ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH \
    && RUN node -v \
    && RUN npm -v

########################################################## Install Dracut ###############################################

RUN apt-get -qy install dracut

########################################################### Install SQL #################################################


ENV MYSQL_USER=mysql \
    MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_RUN_DIR=/run/mysqld \
    MYSQL_LOG_DIR=/var/log/mysql

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server\
    && rm -rf ${MYSQL_DATA_DIR} \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get -y install gcc mono-mcs  \
    && rm -rf /var/lib/apt/lists/*

######################################################## Install python packages ######################################

RUN apt-get install -y python3.6 && \
    apt-get install -y python3.6-dev \
    && apt-get install -y build-essential python3.6 python3.6-dev python3-pip python3.6-venv \
    && apt-get install -y git \
    && python3.6 -m pip install pip --upgrade \
    && python3.6 -m pip install wheel \
    && pip install numpy scipy pandas matplotlib

######################################################## install perl ################################################
RUN apt-get install -y perl \
    && apt-get update && apt-get install -y \
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
RUN echo "" > /etc/machine-id && echo "" > /var/lib/dbus/machine-id \
    && sed -i -e 's/^AcceptEnv LANG LC_\*$/#AcceptEnv LANG LC_*/' /etc/ssh/sshd_config\
    && echo "root:root" | chpasswd

################################################### Gcloud,AWS,tmux ##########################################################

RUN apt-get update && apt-get install -y \
      curl \
      python-pip 

#Gcloud
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz \
  && mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && DEBIAN_FRONTEND=noninteractive && /usr/local/gcloud/google-cloud-sdk/install.sh \
  && ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin  # Adding the package path to local

#AWS client
RUN pip install awscli --upgrade --user \
    && ENV PATH=/root/.local/bin:$PATH \
    && DEBIAN_FRONTEND=noninteractive && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

#tmux
RUN apt-get update && \
  apt install -y tmux && \
  apt install -y openssh-server && \
  service ssh start 

EXPOSE 22/tcp


################################################# install Flutter, Mutt ##################################################
RUN apt-get update \
    && apt-get install -y wget \
                            tar\
                       xz-utils \
                            git \
                          unzip \
                          software-properties-common\
			  yum

##installing Java
RUN add-apt-repository -y ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install -y openjdk-11-jdk  

RUN wget https://dl.google.com/dl/android/studio/ide-zips/3.5.3.0/android-studio-ide-191.6010548-linux.tar.gz \
    && tar -C /opt -xvf android-studio-ide-191.6010548-linux.tar.gz \
    && export ANDROID_HOME=$HOME/Android/Sdk  \
    && export PATH=$PATH:$ANDROID_HOME/tools \ 
    && export PATH=$PATH:$ANDROID_HOME/platform-tools\
    && /bin/bash -c "source /root/.bashrc" \
    && wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.12.13+hotfix.5-stable.tar.xz \
    && tar xf flutter_linux_v1.12.13+hotfix.5-stable.tar.xz  && export PATH=/flutter/bin:$PATH \
    && /bin/bash -c "source  /root/.bashrc" && flutter doctor --android-licenses \
    && flutter precache 


RUN yum install mutt
