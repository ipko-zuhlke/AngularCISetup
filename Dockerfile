FROM ubuntu:24.04
ARG NODE_VERSION=lts/jod

SHELL ["/bin/bash", "-c"]


# Install necessary global packages
RUN apt update && apt install curl wget -y
RUN curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb 
# make nvm and node available on shell reload
ENTRYPOINT ["bash", "-c", "source $NVM_DIR/nvm.sh && exec \"$@\"", "--"]

# Copy example angular project to container
ADD . /var/www/app
WORKDIR /var/www/app

RUN chown -R ubuntu:ubuntu .


# Cleanup apt cache to remove image size
RUN rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# run as non-root user
USER ubuntu

# Install nvm and node for user
ENV NVM_DIR=/home/ubuntu/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
RUN source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION



RUN ls -la
# Install packages and disable analytics
RUN source $NVM_DIR/nvm.sh && npm install
RUN source $NVM_DIR/nvm.sh && npx ng analytics disable


# set cmd to bash
CMD ["/bin/bash"]
