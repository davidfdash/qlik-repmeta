# Build stage - use full node image to avoid native module issues with Alpine
FROM node:20-bookworm-slim AS build

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci

COPY . .

# Remove backup files that cause TS errors
RUN rm -f src/*bkp* src/*Copy* src/*copy*

# Set the API URL to use relative path (proxied by ALB)
ENV VITE_API_URL=/api
# Skip tsc type-check, just build with Vite
RUN npx vite build

# Production stage
FROM nginx:alpine

# Copy built assets
COPY --from=build /app/dist /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
