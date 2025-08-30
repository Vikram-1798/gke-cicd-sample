# build
FROM golang:1.22 AS build
WORKDIR /src
COPY app/ ./app/
WORKDIR /src/app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /out/app

# run (distroless)
FROM gcr.io/distroless/base-debian12
ENV PORT=8080
ENV COMMIT_SHA=dev
EXPOSE 8080
COPY --from=build /out/app /app
ENTRYPOINT ["/app"]
