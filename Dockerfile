# Ultra-simplified Dockerfile for Supabase Studio on Render

FROM node:18-slim

# Install required tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Just copy everything - this avoids monorepo complexities
COPY . .

# Set up environment for Render
ENV PORT=3000
EXPOSE 3000

# Install a simple HTTP server to serve a static message
RUN npm install -g serve

# Create a simple HTML file explaining the situation
RUN echo '<!DOCTYPE html><html><head><title>Supabase Studio Notice</title><style>body{font-family:system-ui;line-height:1.6;max-width:800px;margin:40px auto;padding:20px;color:#333}h1{color:#3ecf8e}pre{background:#f4f4f4;padding:15px;border-radius:5px}</style></head><body><h1>Supabase Studio</h1><p>The Supabase Studio interface cannot be directly deployed on Render using this repository.</p><p>For Supabase access, please use one of these options:</p><ol><li>Use <a href="https://supabase.com/dashboard">Supabase Cloud</a> for the managed service</li><li>Follow the <a href="https://supabase.com/docs/guides/self-hosting">self-hosting guide</a> for a complete local setup</li><li>Use the <a href="https://github.com/supabase/supabase/tree/master/docker">Docker Compose setup</a> for local development</li></ol><p>To connect to an existing Supabase instance, use the Supabase CLI or REST API.</p></body></html>' > /app/index.html

# Serve the static notice
CMD ["serve", "-s", "/app", "-l", "3000"]
