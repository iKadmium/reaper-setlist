# Stage 0: Frontend Builder (Platform-independent)
FROM oven/bun:1.1.18-alpine as frontend_builder
WORKDIR /app/frontend
COPY frontend/package.json frontend/bun.lockb ./
RUN bun install --frozen-lockfile
COPY frontend/. .
RUN bun run build

# Stage 1: Unified Rust Backend Builder
# BUILDPLATFORM is the architecture of the machine building the image (e.g., linux/amd64)
# TARGETPLATFORM is the architecture of the image being built (e.g., linux/amd64, linux/arm64)
FROM --platform=$BUILDPLATFORM clux/muslrust:1.70.0-stable AS backend_builder
ARG TARGETPLATFORM

WORKDIR /app/backend

# Infer the Rust target triple from TARGETPLATFORM
ARG RUST_TARGET
RUN case ${TARGETPLATFORM} in \
      "linux/amd64") RUST_TARGET="x86_64-unknown-linux-musl" ;; \
      "linux/arm64") RUST_TARGET="aarch64-unknown-linux-musl" ;; \
      *) echo "Unsupported TARGETPLATFORM: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    echo "Using RUST_TARGET: ${RUST_TARGET}"

# Add the target toolchain (clux/muslrust often has many pre-installed, but this ensures it)
RUN rustup target add ${RUST_TARGET}

COPY backend/Cargo.toml backend/Cargo.lock ./

# Cache dependencies for the current TARGETPLATFORM
# This will be cross-compiled if TARGETPLATFORM != BUILDPLATFORM
RUN mkdir -p src && echo "fn main() {}" > src/lib.rs && cargo build --release --target ${RUST_TARGET}

COPY backend/. .
RUN RUSTFLAGS="-C target-feature=+crt-static" \
    cargo build --release --target ${RUST_TARGET}
RUN strip target/${RUST_TARGET}/release/reaper_setlist_backend

# Stage 2: Final Image (using TARGETPLATFORM to select binary and ensure correct manifest)
# TARGETPLATFORM here ensures that the correct architecture is stamped on the final image.
FROM scratch AS final_image
ARG TARGETPLATFORM
ARG RUST_TARGET # Inherit RUST_TARGET from previous stage

# This COPY uses the binary that was built for the TARGETPLATFORM
COPY --from=backend_builder /app/backend/target/${RUST_TARGET}/release/reaper_setlist_backend /reaper_setlist_backend

# Copy frontend assets
COPY --from=frontend_builder /app/frontend/build /app/frontend/assets

# CA certs if needed (copied from the specific builder stage's context)
COPY --from=backend_builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 8080
ENTRYPOINT ["/reaper_setlist_backend"]
