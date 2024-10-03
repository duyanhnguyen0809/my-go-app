# Step 0 : Download
FROM alpine AS git
RUN apk add --no-cache git
RUN git clone https://github.com/duongdk099/docker_go.git

# Stage 1: Build the Go application
FROM golang:1.18-alpine AS builder
# Set the working directory inside the container
WORKDIR /app

# Copy the Go application to the container
COPY --from=git ./ ./

# Build the Go application
RUN go mod init my-go-app
RUN go env -w CGO_ENABLED=0 GOOS=linux GOARCH=amd64
RUN go build -o myapp ./docker_go
# Stage 2: Create a minimal image
FROM scratch
WORKDIR /app

# Copy the compiled Go binary from the builder stage
COPY --from=builder /app/myapp /myapp

# Set the working directory in the final image

# Expose port 9090
EXPOSE 9090

# Run the Go application
CMD ["/myapp"]