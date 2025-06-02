.PHONY: build-local-image

build-local-image:
	@echo "Building frontend locally..."
	cd frontend && bun install --frozen-lockfile && bun run build
	@echo "Building Docker image locally..."
	docker build -t ikadmium/reaper-setlist:local .
	@echo "Local Docker image ikadmium/reaper-setlist:local built successfully!"

clean-frontend:
	@echo "Cleaning frontend build artifacts..."
	rm -rf frontend/build

clean-image:
	@echo "Cleaning local Docker image..."
	docker rmi ikadmium/reaper-setlist:local || true

clean: clean-frontend clean-image