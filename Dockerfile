# syntax=docker/dockerfile:1.4
FROM node:24.3.0-alpine

WORKDIR /app

# Install specific version of pnpm
RUN corepack enable && corepack prepare pnpm@10.13.1 --activate

# Copy everything
COPY . .

# Install dependencies
RUN pnpm install --frozen-lockfile && pnpm approve-builds

ENV NODE_ENV=production
RUN pnpm build

CMD ["pnpm", "build"]
