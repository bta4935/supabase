# Dockerfile for Supabase Studio on Render - Monorepo Approach

FROM node:18-slim

# Install build essentials
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3 \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm - essential for the monorepo
RUN npm install -g pnpm@8.x

WORKDIR /app

# First, copy workspace configuration
COPY package.json pnpm-workspace.yaml pnpm-lock.yaml .npmrc ./

# Copy the studio app
COPY apps/studio/ ./apps/studio/

# Copy shared packages if needed
COPY packages/ ./packages/

# Install dependencies with pnpm
RUN pnpm install --frozen-lockfile

# Set up environment for Render
ENV PORT=3000
EXPOSE 3000

# Using a direct approach to start Next.js dev server rather than production build
# This is a fallback approach when the production build has issues
WORKDIR /app/apps/studio
CMD ["pnpm", "dev", "--port", "3000", "--hostname", "0.0.0.0"]
