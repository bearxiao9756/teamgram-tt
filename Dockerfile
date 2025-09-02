FROM node:22-alpine

WORKDIR /app

# 安装依赖工具：git、bash、nginx
RUN apk add --no-cache git bash nginx

# 复制依赖文件和本地 dev 依赖
COPY package.json yarn.lock ./
COPY dev ./dev

# 安装依赖
RUN yarn install --frozen-lockfile

# 复制项目源代码
COPY . .

# 构建前端并拷贝到 nginx 目录，然后删除不必要的文件
RUN yarn build:production \
    && cp -r dist/* /usr/share/nginx/html/ \
    && rm -rf node_modules src dev package.json yarn.lock deploy

# 拷贝 SPA nginx 配置
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 容器外访问端口
EXPOSE 54321

# 启动 nginx
CMD ["nginx", "-g", "daemon off;"]
