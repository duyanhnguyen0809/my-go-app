FROM alpine as git
RUN apk add --no-cache git
RUN git clone https://github.com/duyanhnguyen0809/my-go-app.git


FROM golang:1.20-alpine AS builder
WORKDIR /app
COPY --from=git /my-go-app ./
RUN go mod init myapp
RUN go env -w CGO_ENABLED=0 GOOS=linux GOARCH=amd64 
RUN go build -a -installsuffix cgo -o myapp .


FROM scratch
COPY --from=builder /app/myapp /myapp
WORKDIR /app
USER 1000
EXPOSE 9090
CMD [ "/myapp" ]