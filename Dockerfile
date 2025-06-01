# syntax=docker/dockerfile:1.4
# Using a specific syntax for Buildx features like --platform

# Stage 0: Frontend Builder
FROM oven/bun:latest as frontend_builder

WORKDIR /app/frontend

COPY frontend/package.json frontend/bun.lock ./
RUN bun install --frozen-lockfile

COPY frontend/. .
RUN bun run build # Outputs to 'build' folder


# Stage 1: Rust Backend Builder
FROM --platform=$TARGETPLATFORM rust:alpine AS backend_builder
ARG TARGETPLATFORM
ARG RUST_TARGET_TRIPLE_ARG=x86_64-unknown-linux-musl

SHELL ["/bin/sh", "-eux", "-c"]

WORKDIR /app/backend

# Install build dependencies.
RUN apk update && \
    apk add --no-cache \
    musl-dev \
    gcc \
    g++ \
    ca-certificates \
    git \
    cmake \
    make \
    perl \
    && rm -rf /var/cache/apk/*

# Add the x86_64-unknown-linux-musl target to rustup.
RUN rustup target add "${RUST_TARGET_TRIPLE_ARG}"

# Set specific environment variables for compilation
ENV CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_CFLAGS="-O3 -ffunction-sections -fdata-sections -fPIC -fvisibility=hidden -std=c1x -Wall -Wextra -Wbad-function-cast -Wcast-align -Wcast-qual -Wconversion -Wmissing-field-initializers -Wmissing-include-dirs -Wnested-externs -Wredundant-decls -Wshadow -Wsign-compare -Wsign-conversion -Wstrict-prototypes -Wundef -Wuninitialized -g3 -DNDEBUG"
ENV RING_NO_ASM=1
ENV CRATE_CC_NO_DEFAULTS=1
ENV CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_RUSTFLAGS="-C target-feature=+crt-static -C link-arg=-Wl,--gc-sections -C link-arg=-static-pie -C link-arg=-Wl,-z,relro,-z,now -C link-arg=-Wl,-O1 -C link-arg=-Wl,--strip-all -C link-arg=-nodefaultlibs"

# --- Proper Dependency Caching Strategy for Binary Crates ---
COPY backend/Cargo.toml backend/Cargo.lock ./
# Create dummy source files for caching dependencies
RUN mkdir -p src && \
    echo "fn main() { /* dummy main for dependency caching */ }" > src/main.rs && \
    echo "pub fn dummy_lib() { /* dummy lib for dependency caching */ }" > src/lib.rs
# Build dependencies
RUN cargo build --release --target "${RUST_TARGET_TRIPLE_ARG}"
# Clean up dummy files
RUN rm -f src/main.rs src/lib.rs && rmdir src
# --- END NEW CACHING STRATEGY ---

COPY backend/. .
RUN cargo build --release --target "${RUST_TARGET_TRIPLE_ARG}"

# Strip the binary to further reduce its size.
RUN strip target/"${RUST_TARGET_TRIPLE_ARG}"/release/reaper_setlist_backend


# Stage 2: Final Image
FROM scratch AS final_image
ARG TARGETPLATFORM

# Copy the compiled backend binary.
COPY --from=backend_builder /app/backend/target/x86_64-unknown-linux-musl/release/reaper_setlist_backend /reaper_setlist_backend

# Copy frontend assets from the frontend builder to the backend's expected 'assets' directory.
COPY --from=frontend_builder /app/frontend/build /assets

# Add CA certificates (important for HTTPS calls if needed by backend for external requests)
COPY --from=backend_builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Expose the port your application listens on
EXPOSE 3000

# Set the entrypoint for your application
ENTRYPOINT ["/reaper_setlist_backend"]