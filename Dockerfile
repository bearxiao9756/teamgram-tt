# ---------- 构建阶段 ----------
FROM node:22-alpine AS build

WORKDIR /app

# 安装 git 和 bash
RUN apk add --no-cache git bash

# 复制依赖文件和本地 dev 依赖
COPY package.json package-lock.json ./
COPY dev ./dev

# 使用 npm 安装依赖，忽略 peerDeps 冲突
RUN npm install --legacy-peer-deps

# 复制项目源代码
COPY . .

# 构建前端
RUN npm run build:production

# ---------- 生产阶段 ----------
FROM nginx:alpine

# 拷贝构建产物到 Nginx
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
