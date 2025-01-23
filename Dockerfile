# Use a lightweight Node.js image
FROM node:lts-slim

# Set working directory
WORKDIR /src

# Set environment variable to skip downloading prebuilt workers
ENV MEDIASOUP_SKIP_WORKER_PREBUILT_DOWNLOAD="true"

# Install necessary system packages and dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        python3 \
        python3-pip \
        ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Copy package.json and install npm dependencies
COPY package.json .
RUN npm install

# Cleanup unnecessary packages and files
RUN apt-get purge -y --auto-remove build-essential python3-pip \
&& npm cache clean --force \
&& rm -rf /tmp/* /var/tmp/* /usr/share/doc/*

# Copy the application code
COPY app app
COPY public public

# Check if config.js exists, if not copy config.template.js to config.js
RUN if [ ! -f ./app/src/config.js ]; then cp ./app/src/config.template.js ./app/src/config.js; fi

# Set default command to start the application
CMD ["npm", "start"]
