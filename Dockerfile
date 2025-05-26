# Stage 1: Build the Svelte app
FROM oven/bun:latest AS frontend-builder

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package.json bun.lock ./
RUN bun install

# Copy the rest of the application files and build
COPY . .
RUN bun run build


# Stage 2: Run the app with Bun
FROM builder

# Set working directory
WORKDIR /app

# Copy built files from the builder stage
COPY --from=builder /app/build /app

# Install dependencies
RUN bun install

# Expose port and run the app
EXPOSE 3000
CMD ["bun", "run", "start"]