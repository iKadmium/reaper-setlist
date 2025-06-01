# Dockerfile

# Stage 0: Frontend Builder (Platform-independent)
FROM oven/bun:1.1.18-alpine as frontend_builder # Adjust Bun version as needed

WORKDIR /app/frontend

COPY frontend/package.json frontend/bun.lockb ./
RUN bun install --frozen-lockfile # Install dependencies

COPY frontend/. .
RUN bun run build # Run your frontend build command (e.g., creates 'dist' folder)


# Stage 1: Unified Rust Backend Builder
# BUILDPLATFORM is the architecture of the machine building the image (e.g., linux/amd64 on GitHub Actions)
# TARGETPLATFORM is the architecture of the image being built (e.g., linux/amd64, linux/arm64)
FROM --platform=$BUILDPLATFORM clux/muslrust:1.70.0-stable AS backend_builder
ARG TARGETPLATFORM

WORKDIR /app/backend

# Determine the Rust target triple based on TARGETPLATFORM.
# We set this as a shell variable and use it within the same RUN command.
# For subsequent RUN commands, we re-derive it or source a script (as shown below).
ENV RUST_TARGET="" 
RUN case ${TARGETPLATFORM} in \
      "linux/amd64") RUST_TARGET="x86_64-unknown-linux-musl" ;; \
      "linux/arm64") RUST_TARGET="aarch64-unknown-linux-musl" ;; \
      *) echo "Unsupported TARGETPLATFORM: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    echo "Determined RUST_TARGET: ${RUST_TARGET}"; \
    # Add the target. This ensures the target is added *once* per platform.
    rustup target add "${RUST_TARGET}"; \
    # Create a small script to export this variable for *subsequent* RUN commands
    echo "export RUST_TARGET=${RUST_TARGET}" > /usr/local/bin/set_rust_target_env.sh && \
    chmod +x /usr/local/bin/set_rust_target_env.sh

# Copy Cargo.toml and Cargo.lock first for caching dependencies.
# Source the script to get RUST_TARGET into the environment for this RUN command.
COPY backend/Cargo.toml backend/Cargo.lock ./
RUN . /usr/local/bin/set_rust_target_env.sh && \
    mkdir -p src && echo "fn main() {}" > src/lib.rs && \
    cargo build --release --target "${RUST_TARGET}"

# Copy your actual backend source code
COPY backend/. .

# Build the backend for the specified target platform.
# Source the script again to get RUST_TARGET.
RUN . /usr/local/bin/set_rust_target_env.sh && \
    RUSTFLAGS="-C target-feature=+crt-static" \
    cargo build --release --target "${RUST_TARGET}"

# Strip the binary to further reduce its size.
# Source the script again to get RUST_TARGET.
RUN . /usr/local/bin/set_rust_target_env.sh && \
    strip target/"${RUST_TARGET}"/release/your_app_name


# Stage 2: Final Image
FROM scratch AS final_image
ARG TARGETPLATFORM # Inherit TARGETPLATFORM to ensure the correct binary path is chosen

# Determine the Rust target triple again to get the correct binary path for this specific platform.
# This variable will be local to this COPY instruction's context.
ARG FINAL_RUST_TARGET=""
RUN case ${TARGETPLATFORM} in \
      "linux/amd64") FINAL_RUST_TARGET="x86_64-unknown-linux-musl" ;; \
      "linux/arm64") FINAL_RUST_TARGET="aarch64-unknown-linux-musl" ;; \
      *) echo "Unsupported TARGETPLATFORM: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    echo "Final binary path target: ${FINAL_RUST_TARGET}"

# Copy the compiled binary from the backend builder for the specific TARGETPLATFORM.
# The `FINAL_RUST_TARGET` from the previous RUN command is available.
# Use --from-env to correctly access the shell variable from the previous RUN.
COPY --from=backend_builder /app/backend/target/${FINAL_RUST_TARGET}/release/your_app_name /your_app_name

# Copy frontend assets from the frontend builder
COPY --from=frontend_builder /app/frontend/dist /app/frontend/dist

# IMPORTANT: Add CA certificates for HTTPS requests if needed by *outgoing* backend calls.
# If you confirmed *no* outgoing HTTPS, you can omit this.
# If you use `reqwest` with `rustls-tls-webpki-roots`, these are embedded, and you don't need this line.
COPY --from=backend_builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Optional: Create a non-root user (specify UID/GID as scratch has no user management tools)
# USER 65532:65532

# Expose the port your Axum app listens on (for documentation)
EXPOSE 8080

# Set the entrypoint for your application
ENTRYPOINT ["/your_app_name"]
