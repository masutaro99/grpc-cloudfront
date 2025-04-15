# build the app.
FROM golang:1.23 AS build-env

# set the working dir.
WORKDIR /app

# copy the go module dependency files.
COPY go.mod go.sum ./

# download the go module dependencies.
RUN go mod download

# copy the app source code.
COPY . .

# build the go app binary.
RUN CGO_ENABLED=0 go build -o main ./cmd/main.go

# set up the container.
FROM debian:12

# set the working dir.
WORKDIR /app

# copy the built app binary from the build-env.
COPY --from=build-env /app/main ./main

# expose the port.
EXPOSE 50051

# command to run the app.
CMD ["./main"]