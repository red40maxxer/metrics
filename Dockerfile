# Base image
FROM node:20-bookworm-slim

# Copy repository
COPY . /metrics
WORKDIR /metrics

# Setup
RUN chmod +x /metrics/source/app/action/index.mjs \
  && apt-get update \
  && apt-get install -y wget gnupg ca-certificates libgconf-2-4 \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'test -f /etc/apt/sources.list.d/google-chrome.list || echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 libx11-xcb1 libxtst6 lsb-release --no-install-recommends \
  && apt-get install -y curl unzip \
  && curl -fsSL https://deno.land/x/install/install.sh | DENO_INSTALL=/usr/local sh \
  && apt-get install -y ruby-full git g++ cmake pkg-config libssl-dev build-essential xz-utils \
  && gem install licensed \
  && apt-get install -y python3 \
  && rm -rf /var/lib/apt/lists/* \
  && npm ci \
  && npm run build

# Environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV PUPPETEER_BROWSER_PATH "google-chrome-stable"

# Execute GitHub action
ENTRYPOINT node /metrics/source/app/action/index.mjs
