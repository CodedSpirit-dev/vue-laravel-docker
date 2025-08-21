# docker/node/Dockerfile
FROM node:24-bookworm-slim

# Install basic tools and clean cache
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates git bash \
 && rm -rf /var/lib/apt/lists/*

# Configure and install Volta
ENV VOLTA_HOME=/opt/volta
ENV PATH=$VOLTA_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN curl -fsSL https://get.volta.sh | bash -s -- --skip-setup

# Set Node and pnpm versions with Volta
RUN volta install node@24 pnpm@9

# The Node.js image already has a 'node' user with UID/GID 1000
# So we'll use that instead of creating a new one

# Set working directory
WORKDIR /var/www/html

# Change ownership to the existing 'node' user
RUN chown -R node:node /var/www/html

# Switch to the existing 'node' user
USER node

# Copy package files with correct ownership
COPY --chown=appuser:appgroup package.json pnpm-lock.yaml* ./

# Install dependencies
RUN pnpm install

# Copy the rest of the project files
COPY --chown=appuser:appgroup . .

# Expose Vite port
EXPOSE 5173

# Default command
CMD ["pnpm", "run", "dev", "--host", "0.0.0.0"]