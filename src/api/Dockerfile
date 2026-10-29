# syntax=docker/dockerfile:1

# Stage 1: Install production dependencies
FROM node:22-bookworm-slim AS deps

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev && npm cache clean --force


# Stage 2: Production runtime
FROM node:22-bookworm-slim AS runtime

ENV NODE_ENV=production

WORKDIR /app

# Copy production dependencies
COPY --chown=node:node --from=deps /app/node_modules ./node_modules

# Copy application source
COPY --chown=node:node server.js ./

# Run as non-root user
USER node

# Container health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD node -e "fetch('http://127.0.0.1:3000/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"

EXPOSE 3000

CMD ["node", "server.js"]