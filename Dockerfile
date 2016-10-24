FROM aarch64/ubuntu
RUN apt-get update && apt-get install -y build-essential libssl-dev wget
RUN apt-get update && apt-get install -y git python
RUN apt-get update && apt-get install -y avahi-daemon libavahi-compat-libdnssd-dev

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV NODE_VERSION 4.6.1
RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash
RUN source ~/.nvm/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION && nvm use default && npm config set production
RUN git clone https://github.com/htreu/OpenHAB-HomeKit-Bridge.git
RUN source ~/.nvm/nvm.sh && nvm use default && cd /OpenHAB-HomeKit-Bridge && `nvm which default` \
  --max_semi_space_size=2 \
  --max_old_space_size=512 \
  --max_executable_size=256 \
  /root/.nvm/versions/node/v4.6.1/bin/npm update

# install everything else
RUN apt-get update && apt-get install -y supervisor && mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /var/run/dbus
ADD start-ohb.sh /start-ohb.sh
RUN chmod +x /start-ohb.sh
EXPOSE 5353 51826
CMD ["/usr/bin/supervisord"]
