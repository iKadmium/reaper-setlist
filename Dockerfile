# Dockerfile

# Stage 0: Frontend Builder (Platform-independent)
# Adjust Bun version as needed
FROM oven/bun:1.1.18-alpine as frontend_builder 

WORKDIR /app/frontend

# Use the correct Bun lock file name: bun.lock
COPY frontend/package.json frontend/bun.lock ./
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
# For subsequent RUN commands, we create a script to re-export it.
ENV RUST_TARGET_TRIPLE=""
RUN case ${TARGETPLATFORM} in \
      "linux/amd64") RUST_TARGET_TRIPLE="x86_64-unknown-linux-musl" ;; \
      "linux/arm64") RUST_TARGET_TRIPLE="aarch64-unknown-linux-musl" ;; \
      *) echo "Unsupported TARGETPLATFORM: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    echo "Determined RUST_TARGET_TRIPLE: ${RUST_TARGET_TRIPLE}"; \
    # Add the target. This ensures the target is added *once* per platform.
    rustup target add "${RUST_TARGET_TRIPLE}"; \
    # Create a small script to export this variable for *subsequent* RUN commands
    echo "export RUST_TARGET_TRIPLE=${RUST_TARGET_TRIPLE}" > /usr/local/bin/set_rust_target_env.sh && \
    chmod +x /usr/local/bin/set_rust_target_env.sh

# Copy Cargo.toml and Cargo.lock first for caching dependencies.
# Source the script to get RUST_TARGET_TRIPLE into the environment for this RUN command.
COPY backend/Cargo.toml backend/Cargo.lock ./
RUN . /usr/local/bin/set_rust_target_env.sh && \
    mkdir -p src && echo "fn main() {}" > src/lib.rs && \
    cargo build --release --target "${RUST_TARGET_TRIPLE}"

# Copy your actual backend source code
COPY backend/. .

# Build the backend for the specified target platform.
# Source the script again to get RUST_TARGET_TRIPLE.
RUN . /usr/local/bin/set_rust_target_env.sh && \
    RUSTFLAGS="-C target-feature=+crt-static" \
    cargo build --release --target "${RUST_TARGET_TRIPLE}"

# Strip the binary to further reduce its size.
# Source the script again to get RUST_TARGET_TRIPLE.
RUN . /usr/local/bin/set_rust_target_env.sh && \
    strip target/"${RUST_TARGET_TRIPLE}"/release/reaper_setlist_backend


# Stage 2: Final Image
FROM scratch AS final_image
ARG TARGETPLATFORM 

# IMPORTANT: You cannot have RUN commands in a scratch image.
# We will derive the path directly here for the COPY instruction.
# Buildx will use the correct backend_builder output for the current TARGETPLATFORM.
# Directly determine the target triple for the COPY path.
# This logic must be consistent with the backend_builder's RUST_TARGET_TRIPLE logic.

# The COPY instruction itself cannot run a shell command.
# It can use ARGs directly, but if the ARG is not passed, it fails.
# The simplest approach is to just hardcode the two possible paths for COPY.
# Buildx will ensure the correct one is used.

# A more robust way, without complex build-args for the final stage,
# is to structure the output directory in `backend_builder` to *not* use TARGETPLATFORM in its name,
# or to ensure the `COPY` instruction correctly maps based on TARGETPLATFORM.

# Let's simplify the final copy by removing the dynamic path logic from the scratch image.
# The COPY operation can be made more robust if the backend_builder always outputs to a known path.
# However, the current path `target/aarch64-unknown-linux-musl/release/your_app_name` is standard.

# Let's try to determine the path directly for the COPY, similar to how the builder does.
# This still has the issue if FINAL_RUST_TARGET is not an ARG, but it's simpler.

# One more try at the final_image stage, leveraging ARG and Docker's build-time variables:
# This needs a specific build-arg for the final stage too.

# The most reliable way for the final stage to get the target triple without a RUN command:
# Pass it as a build-arg to the final stage from the GitHub Action.

# Let's restart the final stage part:
# This requires a corresponding `build-args` in the GHA.

FROM scratch AS final_image
ARG FINAL_BUILD_TRIPLE

# Copy the compiled binary from the backend builder.
# The path depends on the `FINAL_BUILD_TRIPLE` ARG.
COPY --from=backend_builder /app/backend/target/${FINAL_BUILD_TRIPLE}/release/reaper_setlist_backend /reaper_setlist_backend

# Copy frontend assets from the frontend builder
COPY --from=frontend_builder /app/frontend/build /app/assets

# Add CA certificates (important for HTTPS calls if needed by backend)
COPY --from=backend_builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 8080
ENTRYPOINT ["/reaper_setlist_backend"]
