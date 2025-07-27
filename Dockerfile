# 使用官方Golang镜像作为构建环境
FROM golang:1.24-alpine AS builder

WORKDIR /app

# 复制go.mod文件以下载依赖
COPY go.mod .

RUN go mod download

# 复制源代码
COPY . .

# 构建应用
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# 使用最小的alpine镜像作为运行环境
FROM alpine:latest

WORKDIR /root/

# 从builder阶段复制编译好的二进制文件
COPY --from=builder /app/main .

# 暴露端口
EXPOSE 8080

# 运行可执行文件
CMD ["./main"]