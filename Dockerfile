# syntax=docker/dockerfile:1.4
FROM node:24.3.0-alpine

WORKDIR /app

# Install specific version of pnpm
RUN corepack enable && corepack prepare pnpm@10.13.1 --activate

# Copy everything
COPY . .

# Install dependencies
RUN pnpm install --frozen-lockfile && pnpm approve-builds

# Set SKIP_ENV_VALIDATION only during build, not runtime
ENV SKIP_ENV_VALIDATION=true
ENV NODE_ENV=production
RUN pnpm build

# Unset the skip validation for runtime
ENV SKIP_ENV_VALIDATION=

EXPOSE 3000

CMD ["pnpm", "start"]
