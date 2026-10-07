# Step 1: Build the Rust application
FROM rust:latest AS builder
WORKDIR /usr/src/pointercrate

# We set a dummy URL and tell SQLx to skip compile-time checking
ENV SQLX_OFFLINE=true
ENV DATABASE_URL=postgres://localhost/dummy

COPY . .
RUN rm -f Cargo.lock

# We use standard build flags that force compilation without checking live tables
RUN cargo build --release --bin pointercrate-example

# Step 2: Create a minimal runner image
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y libssl-dev ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/src/pointercrate/target/release/pointercrate-example /usr/local/bin/pointercrate-example
EXPOSE 8080
CMD ["pointercrate-example"]
