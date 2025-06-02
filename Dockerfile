# Stage 1: Build the Rust Backend
# Inherit from a Rust image based on Alpine for musl support out of the box.
FROM clux/muslrust:stable AS backend-builder

# Install build essentials and musl cross toolchains for both arches
# Alpine uses 'apk' for package management.
RUN apt-get update && \
    apt-get install -y musl-tools gcc-aarch64-linux-gnu gcc-x86-64-linux-gnu curl || true && \
    ARCH=$(uname -m) && \
    if [ "$ARCH" = "aarch64" ]; then \
        if ! command -v x86_64-linux-musl-gcc >/dev/null 2>&1; then \
            curl -LO https://musl.cc/x86_64-linux-musl-cross.tgz && \
            tar -xzf x86_64-linux-musl-cross.tgz -C /opt && \
            ln -s /opt/x86_64-linux-musl-cross/bin/x86_64-linux-musl-gcc /usr/local/bin/x86_64-linux-musl-gcc; \
        fi \
    elif [ "$ARCH" = "x86_64" ]; then \
        if ! command -v aarch64-linux-musl-gcc >/dev/null 2>&1; then \
            curl -LO https://musl.cc/aarch64-linux-musl-cross.tgz && \
            tar -xzf aarch64-linux-musl-cross.tgz -C /opt && \
            ln -s /opt/aarch64-linux-musl-cross/bin/aarch64-linux-musl-gcc /usr/local/bin/aarch64-linux-musl-gcc; \
        fi \
    fi

# Add musl targets for cross-compilation
# This ensures cargo knows about and can build for these targets.
RUN rustup target add x86_64-unknown-linux-musl aarch64-unknown-linux-musl

# Set the default target for static linking
ENV RUSTFLAGS="-C target-feature=+crt-static"

WORKDIR /app

# Copy backend source code
COPY ./backend ./backend

# Set the working directory for the backend
WORKDIR /app/backend

# Build the Rust backend for the current architecture only
ARG TARGETARCH
RUN cargo build --release --target ${TARGETARCH}-unknown-linux-musl

# Move the compiled binary to a generic, architecture-agnostic path
RUN cp ./target/${TARGETARCH}-unknown-linux-musl/release/reaper_setlist_backend /app/reaper_setlist_backend_final

# Stage 2: Final Production Image
# Inherit from scratch for a minimal image containing only the executable and assets
FROM scratch

ARG TARGETARCH
# Copy the frontend assets (from the pre-built 'build' output) into the final image.
# The `COPY` command will create the /assets directory if it doesn't exist.
# This assumes 'bun run build' has been executed locally or in a prior CI step
# BEFORE the docker build command is run.
COPY ./frontend/build /assets

# Copy the statically linked backend executable from its generic path.
# This path is now consistent regardless of the target architecture being built.
COPY --from=backend-builder /app/reaper_setlist_backend_final /reaper_setlist_backend

# Set the entrypoint to run the backend application
ENTRYPOINT ["/reaper_setlist_backend"]
