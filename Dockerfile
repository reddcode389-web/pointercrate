# Step 1: Build the Rust application using the latest Rust version
FROM rust:latest AS builder
WORKDIR /usr/src/pointercrate
COPY . .
# This deletes the broken lock file so Rust can auto-generate a fresh one
RUN rm -f Cargo.lock
RUN cargo build --release --bin pointercrate-example

# Step 2: Create a minimal runner image
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y libssl-dev ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/src/pointercrate/target/release/pointercrate-example /usr/local/bin/pointercrate-example
EXPOSE 8080
CMD ["pointercrate-example"]
