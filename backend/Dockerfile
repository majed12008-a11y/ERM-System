FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY tsconfig.json ./
COPY src/ ./src/
RUN npm run build

FROM node:22-alpine AS runner
WORKDIR /app
RUN addgroup --system app && adduser --system --ingroup app app
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force
COPY --from=builder /app/dist ./dist
RUN apk add --no-cache postgresql-client && \
    mkdir -p /app/backups /app/uploads && chown -R app:app /app
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/api/v1/monitoring/health || exit 1
USER app
EXPOSE 8080
CMD ["node", "dist/index.js"]
