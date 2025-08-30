# Stage 1: Build the custom Caddy binary
# We use the official Caddy 2.10 builder image, which includes the necessary tools.
FROM caddy:2.10-builder AS builder

# Use Docker's built-in caching to speed up future builds
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    xcaddy build \
    --with github.com/caddy-dns/directadmin \
    --with github.com/mholt/caddy-dynamicdns \
    --with github.com/mietzen/caddy-dynamicdns-cmd-source \
    --with github.com/caddy-dns/acmedns

# Stage 2: Create the final, lean production image
# Start from the standard Caddy 2.10 image.
FROM caddy:2.10

# Copy only the custom-built Caddy binary from the builder stage.
# This keeps the final image small and clean.
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
