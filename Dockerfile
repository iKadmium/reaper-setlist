# Dockerfile

# Stage 0: Frontend Builder (Platform-independent)
# Using 'latest' for Bun, which is typically Debian-based.
FROM oven/bun:latest as frontend_builder

WORKDIR /app/frontend

# Use the correct Bun lock file name: bun.lock
COPY frontend/package.json frontend/bun.lock ./
RUN bun install --frozen-lockfile

COPY frontend/. .
RUN bun run build # Run your frontend build command (outputs to 'build' folder)


# Stage 1: Unified Rust Backend Builder
# BUILDPLATFORM is the architecture of the machine building the image (e.g., linux/amd64 on GitHub Actions)
# TARGETPLATFORM is the architecture of the image being built (e.g., linux/amd64, linux/arm64)
FROM --platform=$BUILDPLATFORM clux/muslrust:latest AS backend_builder
ARG TARGETPLATFORM

# Explicitly set the shell for RUN commands in this stage to /bin/sh.
SHELL ["/bin/sh", "-eux", "-c"]

WORKDIR /app/backend

# Install ca-certificates (for the builder itself to fetch crates via HTTPS, etc.)
# libssl-dev and pkg-config are no longer needed if using rustls for reqwest.
RUN apt-get update && apt-get install -y ca-certificates

# Determine the Rust target triple based on TARGETPLATFORM.
# This variable will be set as a shell variable for this RUN command
# and then exported to a script for subsequent RUN commands.
ENV RUST_TARGET_TRIPLE=""
RUN case ${TARGETPLATFORM} in \
      "linux/amd64") RUST_TARGET_TRIPLE="x86_64-unknown-linux-musl" ;; \
      "linux/arm64") RUST_TARGET_TRIPLE="aarch64-unknown-linux-musl" ;; \
      *) echo "Unsupported TARGETPLATFORM: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    echo "Determined RUST_TARGET_TRIPLE: ${RUST_TARGET_TRIPLE}"; \
    rustup target add "${RUST_TARGET_TRIPLE}"; \
    echo "export RUST_TARGET_TRIPLE=${RUST_TARGET_TRIPLE}" > /usr/local/bin/set_rust_target_env.sh && \
    chmod +x /usr/local/bin/set_rust_target_env.sh

# Copy Cargo.toml and Cargo.lock first for caching dependencies.
COPY backend/Cargo.toml backend/Cargo.lock ./
RUN . /usr/local/bin/set_rust_target_env.sh && \
    mkdir -p src && echo "fn main() {}" > src/lib.rs && \
    cargo build --release --target "${RUST_TARGET_TRIPLE}"

# Copy your actual backend source code
COPY backend/. .

# Build the backend for the specified target platform.
RUN . /usr/local/bin/set_rust_target_env.sh && \
    RUSTFLAGS="-C target-feature=+crt-static" \
    cargo build --release --target "${RUST_TARGET_TRIPLE}"

# Strip the binary to further reduce its size.
RUN . /usr/local/bin/set_rust_target_env.sh && \
    strip target/"${RUST_TARGET_TRIPLE}"/release/reaper_setlist_backend


# Stage 2: Final Image
FROM scratch AS final_image
ARG TARGETPLATFORM # Inherit TARGETPLATFORM for multi-platform manifest
ARG FINAL_BUILD_TRIPLE # This ARG will be set by the GHA `build-args`

# Copy the compiled backend binary.
COPY --from=backend_builder /app/backend/target/${FINAL_BUILD_TRIPLE}/release/reaper_setlist_backend /reaper_setlist_backend

# Copy frontend assets from the frontend builder to the backend's expected 'assets' directory.
COPY --from=frontend_builder /app/frontend/build /assets

# Add CA certificates (important for HTTPS calls if needed by backend for external requests)
# Even with rustls, it's good to include if your backend makes external HTTPS calls for other reasons.
COPY --from=backend_builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Optional: Create a non-root user (specify UID/GID as scratch has no user management tools)
# USER 65532:65532

# Expose the port your application listens on
EXPOSE 3000

# Set the entrypoint for your application
ENTRYPOINT ["/reaper_setlist_backend"]
