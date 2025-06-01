# Dockerfile

# Stage 0: Frontend Builder (Platform-independent)
FROM oven/bun:latest as frontend_builder

WORKDIR /app/frontend

COPY frontend/package.json frontend/bun.lock ./
RUN bun install --frozen-lockfile

COPY frontend/. .
RUN bun run build # Outputs to 'build' folder


# Stage 1: Certificate Provider (to get CA certificates for the final scratch image)
FROM alpine:latest as certs_provider
RUN apk add --no-cache ca-certificates


# Stage 2: Final Image
FROM scratch AS final_image
ARG TARGETPLATFORM

# Copy the compiled backend binary from the host's build context.
# This assumes 'cross' has already built your binary and placed it here:
# ./target/x86_64-unknown-linux-musl/release/reaper_setlist_backend
COPY target/x86_64-unknown-linux-musl/release/reaper_setlist_backend /reaper_setlist_backend

# Copy frontend assets from the frontend builder stage.
COPY --from=frontend_builder /app/frontend/build /assets

# Add CA certificates from the certs_provider stage.
COPY --from=certs_provider /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Optional: Create a non-root user
# USER 65532:65532

# Expose the port your application listens on
EXPOSE 3000

# Set the entrypoint for your application
ENTRYPOINT ["/reaper_setlist_backend"]