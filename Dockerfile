FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

ENV PUPPETEER_CACHE_DIR=/app

RUN apt-get update && apt-get install -y curl vim

# install latest versions of nodejs/npm (19.2.0/9.2.0) and php 
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get install -y php php-zip && \
    npm install -g npm@9.2.0

# install the chromium browser correctly into the docker 
# (based on: https://github.com/puppeteer/puppeteer/blob/main/docker/Dockerfile)
RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-khmeros fonts-kacst fonts-freefont-ttf libxss1 \
    --no-install-recommends

# #install puppeteer
RUN npm install -g puppeteer --unsafe-perm=true -allow-root

# For composer usage
COPY composer.json composer.lock test.php /app/

COPY --from=composer /usr/bin/composer /usr/bin/composer

# Finally installing all required folders/packages into the project
RUN cd /app && npm i puppeteer && composer install

# Purge cache 
RUN rm -rf /var/lib/apt/lists/* 

RUN groupadd --gid 1000 demouser && useradd --uid 1000 --gid 1000 -m demouser && echo "demouser:demouser" | chpasswd && chown -R demouser: /app

USER demouser
WORKDIR /app

# Use it to show magic :)
# RUN wget https://github.com/spatie/browsershot/archive/refs/tags/3.57.2.tar.gz -P /app && \
#     tar -xf /app/3.57.2.tar.gz && rm -r /app/3.57.2.tar.gz && \
#     rm -r vendor/spatie/browsershot/ && \ 
#     cp -r /app/browsershot-3.57.2/ /app/vendor/spatie/browsershot/ 