# Dockerfile for Render deployment
# Based on the Studio Dockerfile

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

# Build the Studio
RUN pnpm --filter studio exec next build

# Prepare for production
WORKDIR /app
COPY apps/studio/public ./apps/studio/public
COPY apps/studio/.next/standalone ./
COPY apps/studio/.next/static ./apps/studio/.next/static

# Set the port that Render will use
ENV PORT=3000
EXPOSE 3000

# Start the application
CMD ["node", "apps/studio/server.js"]
