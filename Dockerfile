# Dockerfile for Render deployment - Modified for Render.com

FROM node:20-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# Install required dependencies
RUN apt-get update -qq && \
  apt-get install -y --no-install-recommends \
  git \
  python3 \ 
  ca-certificates \
  build-essential && \ 
  rm -rf /var/lib/apt/lists/* && \
  update-ca-certificates

RUN npm install -g pnpm@9.15.5

WORKDIR /app

# Copy project files
COPY . .

# Install dependencies
RUN pnpm install --frozen-lockfile

# Add an explicit step to find where the next.config.js is located
RUN find /app -name "next.config.js" | grep studio

# Build the Studio with explicit output options
RUN cd apps/studio && npx next build

# Set up environment variables
ENV PORT=3000
ENV HOST=0.0.0.0
EXPOSE 3000

# Create a simple start script to handle starting the Next.js server
RUN echo '#!/bin/bash\ncd /app/apps/studio && node server.js' > /app/start.sh \
    && chmod +x /app/start.sh

# Start the application using our custom script
CMD ["/app/start.sh"]
