# Stage 1: Build the Svelte app
FROM oven/bun:latest AS frontend-builder

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY frontend/package.json frontend/bun.lock ./
RUN bun install

# Copy the rest of the application files and build
COPY frontend ./
RUN bun run build


FROM rust:alpine AS backend-builder
WORKDIR /app

# Install build dependencies for static OpenSSL
RUN apk add --no-cache musl-dev openssl-dev openssl-libs-static

COPY backend/Cargo.toml backend/Cargo.lock ./
RUN cargo fetch
COPY backend/src ./src
RUN cargo build --release

# Stage 2: Run the app with Bun
FROM alpine:latest
WORKDIR /app

# Copy built files from the builder stage
COPY --from=frontend-builder /app/build ./assets
COPY --from=backend-builder /app/target/release/reaper_setlist_backend ./
RUN apk add --update --no-cache openssl gcompat


# Expose port and run the app
EXPOSE 3000
ENTRYPOINT ["./reaper_setlist_backend"]