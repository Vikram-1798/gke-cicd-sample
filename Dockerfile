# --- build stage ---
FROM golang:1.22 AS build
WORKDIR /src/app

# Copy only go.mod first
COPY app/go.mod ./
# This will be a no-op if there are no external deps
RUN go mod download || true

# Copy the rest and generate go.sum if needed
COPY app/ ./
RUN go mod tidy

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /out/app .

# --- runtime stage ---
FROM gcr.io/distroless/static:nonroot
ENV PORT=8080
ENV COMMIT_SHA=dev
EXPOSE 8080
COPY --from=build /out/app /app
USER nonroot:nonroot
ENTRYPOINT ["/app"]
