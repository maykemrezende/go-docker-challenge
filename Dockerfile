# Start from the latest golang base image
FROM golang:1.20.5-alpine as builder

# Add Maintainer Info
LABEL maintainer="Mayke Rezende <maykemrezende@gmail.com>"

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod
COPY ./src/go.mod ./

# Download all dependencies. Dependencies will be cached if the go.mod file is not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY ./src/*.go .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o main .

# Start a new stage from scratch
FROM scratch

# Copy the binary from builder stage
COPY --from=builder ./app/main ./main

# Command to run the executable
CMD ["./main"]