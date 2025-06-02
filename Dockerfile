ARG TARGETARCH
# X86_64: x86_64-unknown-linux-musl -> amd64
# AARCH64: aarch64-unknown-linux-musl -> arm64

FROM ghcr.io/rust-cross/rust-musl-cross:${TARGETARCH}-musl AS backend-builder
ARG TARGETARCH

WORKDIR /app
COPY ./backend/Cargo.toml ./backend/Cargo.lock ./
RUN mkdir src
RUN echo 'fn main() {}' > src/main.rs
RUN cargo build --target ${TARGETARCH}-unknown-linux-musl --release
COPY ./backend/ ./
RUN cargo build --target ${TARGETARCH}-unknown-linux-musl --release

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
