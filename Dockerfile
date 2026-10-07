# Step 1: Build the Rust application
FROM rust:latest AS builder
WORKDIR /usr/src/pointercrate

# We tell SQLX to connect directly to the database link provided below
ARG DATABASE_URL=postgres://avnadmin:AVNS_Fo2vkEPuHOrxIcNLCAp@://aivencloud.com

ENV DATABASE_URL=${DATABASE_URL}

COPY . .
RUN rm -f Cargo.lock
RUN cargo build --release --bin pointercrate-example

# Step 2: Create a minimal runner image
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y libssl-dev ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/src/pointercrate/target/release/pointercrate-example /usr/local/bin/pointercrate-example
EXPOSE 8080
CMD ["pointercrate-example"]
