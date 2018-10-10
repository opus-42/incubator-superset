FROM debian:latest

COPY ./incubator-superset /root/incubator-superset

# INSTALL LIBRARY
WORKDIR /root/incubator-superset
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential gcc python3 python3-dev python3-pip libssl-dev libffi-dev  libldap2-dev libsasl2-dev libldap2-dev
RUN pip3 install -r requirements.txt
RUN pip3 install -e .

# INIT SUPERSET 
WORKDIR /root
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN fabmanager create-admin --app superset \
    --username admin \
    --firstname admin \
    --lastname test \
    --email test@na.na \
    --password admin
RUN superset db upgrade
RUN superset init
RUN superset load_examples

# INSTALL FRONT-END
WORKDIR /root/incubator-superset/superset/assets
RUN apt-get install -y pkg-config curl bzip2 g++ python git make gcc-multilib node-gyp
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && apt-get install -y nodejs
RUN npm install -g yarn
RUN yarn install
RUN npm run build
