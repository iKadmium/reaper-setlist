# Stage 1: Build the Rust Backend
# Inherit from a Rust image based on Alpine for musl support out of the box.
FROM rust:alpine AS backend-builder

# Install build essentials and openssl-dev for dependencies like 'ring'
# Alpine uses 'apk' for package management.
RUN apk add --no-cache build-base openssl-dev

# Add musl targets for cross-compilation within this stage.
# This ensures cargo knows about and can build for these targets.
# We run this in a single command as requested.
RUN rustup target add x86_64-unknown-linux-musl aarch64-unknown-linux-musl

# Set the default target for static linking
ENV RUSTFLAGS="-C target-feature=+crt-static"

WORKDIR /app

# Copy backend source code
COPY ./backend ./backend

# Set the working directory for the backend
WORKDIR /app/backend

# Build the Rust backend for the appropriate musl target based on the current architecture.
# `uname -m` gets the architecture (e.g., x86_64, aarch64) and we append -unknown-linux-musl.
# This ensures we explicitly build for the musl target that Alpine provides.
RUN cargo build --release --target $(uname -m)-unknown-linux-musl

# Move the compiled binary to a generic, architecture-agnostic path.
# We use the same dynamic target determination as in the build command.
RUN mv ./target/$(uname -m)-unknown-linux-musl/release/reaper_setlist_backend /app/reaper_setlist_backend_final

# Stage 2: Final Production Image
# Inherit from scratch for a minimal image containing only the executable and assets
FROM scratch

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
