FROM ubuntu:24.04
ARG NODE_VERSION=24

SHELL ["/bin/bash", "-c"]

ENV NVM_DIR=/root/.nvm

# Install necessary packages
RUN apt update && apt install curl wget -y
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
RUN source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get -y install ./google-chrome-stable_current_amd64.deb

# make nvm and node available on shell reload
ENTRYPOINT ["bash", "-c", "source $NVM_DIR/nvm.sh && exec \"$@\"", "--"]

# Copy example angular project to container
ADD . /var/www/app
WORKDIR /var/www/app

RUN ls -la
# Install packages and disable analytics
RUN source $NVM_DIR/nvm.sh && npm install
RUN source $NVM_DIR/nvm.sh && npx ng analytics disable

# Cleanup apt cache to remove image size
RUN rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# set cmd to bash
CMD ["/bin/bash"]
