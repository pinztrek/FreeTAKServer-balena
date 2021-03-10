FROM balenalib/aarch64-ubuntu-python:3.8-bionic-build
#FROM balenalib/aarch64-ubuntu:focal-build

MAINTAINER pinztrek

ARG FTS_VERSION=1.5.12

RUN apt-get update 
RUN apt-get install -y --no-install-recommends curl build-essential netbase
RUN apt-get install -y --no-install-recommends libxml2-dev libxslt-dev libffi-dev libz-dev libssl-dev 

#JAB for debug purposes
RUN apt-get install -y --no-install-recommends vim-tiny net-tools

RUN pip3 --version && python3 --version

RUN pip3 install wheel 
RUN pip3 install flask-login 

# OpenSSL needs rust, get it first
#RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
#RUN ln -s $HOME/.cargo/env /etc/profile.d/cargo_env.sh
#RUN pip3 install pyOpenSSL
#RUN pip3 install flask-httpauth

RUN pip3 install FreeTAKServer==${FTS_VERSION} && \
    pip3 check FreeTakServer

RUN useradd -ms /bin/bash fts && \
    mkdir -p -m 775 /data && \
    chown fts:fts /data  /home/fts


# pip installs in different dirs depending on if from debian or from python... we don't care
RUN ln -s /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/dist-packages

RUN  sed -i s='logs'='/data/logs'=g /usr/local/lib/python3.8/dist-packages/FreeTAKServer/controllers/configuration/LoggingConstants.py && \
    sed -i 's+DBFilePath = .*+DBFilePath = "/data/FTSDataBase.db"+g' /usr/local/lib/python3.8/dist-packages/FreeTAKServer/controllers/configuration/MainConfig.py && \
#    sed -i s=FreeTAKServerDataPackageDataBase.db=/data/DataPackageDataBase.db=g /usr/local/lib/python3.8/dist-packages/FreeTAKServer/controllers/configuration/DataPackageServerConstants.py && \
    sed -i s=FreeTAKServerDataPackageFolder=/data/DataPackageFolder=g /usr/local/lib/python3.8/dist-packages/FreeTAKServer/controllers/configuration/DataPackageServerConstants.py && \
    sed -i s={MainPath}/FreeTAKServerDataPackageFolder=/data/DataPackageFolder=g /usr/local/lib/python3.8/dist-packages/FreeTAKServer/controllers/configuration/MainConfig.py

# Should not need these
#RUN chmod 777 /usr/local/lib/python3.8/dist-packages/FreeTAKServer/controllers/configuration/MainConfig.py && \
#    chmod 777 /usr/local/lib/python3.8/dist-packages/FreeTAKServer/controllers/configuration

# certs dir has to be writable due to cert generation
#RUN sed -i 's+certsPath = .*+certsPath = "/data/certs"+g' /usr/local/lib/python3.8/dist-packages/FreeTAKServer/controllers/configuration/MainConfig.py
RUN sed -i 's+{MainPath}/certs+/data/certs+g' /usr/local/lib/python3.8/dist-packages/FreeTAKServer/controllers/configuration/MainConfig.py
#RUN sed -i 's+CAkey = .*+CAkey = str(Path(fr'/data/certs/ca.key))+g' /usr/local/lib/python3.8/dist-packages/FreeTAKServer/controllers/configuration/MainConfig.py

RUN    mkdir -p -m 775 /data/certs && \
    chown fts:fts /data/certs

RUN mkdir -p -m 775 /usr/local/lib/python3.8/dist-packages/FreeTAKServer/ExCheck
RUN mkdir -p -m 775 /usr/local/lib/python3.8/dist-packages/FreeTAKServer/ExCheck/checklist
RUN mkdir -p -m 775 /usr/local/lib/python3.8/dist-packages/FreeTAKServer/ExCheck/template

# Clean up items we no longer need (having this earlier breaks some pip items)
#RUN apt-get remove -y python3-pip curl python3-setuptools build-essential python3-dev && \
#    apt-get autoremove -y && \
#    apt-get autoclean -y && \
#    rm -rf /var/lib/apt/lists/*


COPY start-fts.sh /start-fts.sh
RUN chmod +x /start-fts.sh

EXPOSE 8080
EXPOSE 8087

VOLUME ["/data"]
WORKDIR /data
USER fts

#CMD "/bin/bash"
ENTRYPOINT ["/bin/bash", "/start-fts.sh"]
