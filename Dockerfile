# ---------- 构建阶段 ----------
FROM node:22-alpine AS build
WORKDIR /app

# 复制依赖文件
COPY package.json yarn.lock ./

# 复制本地 dev 依赖
COPY dev ./dev

# 安装依赖
RUN yarn install --frozen-lockfile

# 复制项目文件
COPY . .

# 构建前端
RUN yarn build:production

# ---------- 生产阶段 ----------
FROM nginx:alpine

# 拷贝构建产物到 Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# SPA 支持（可选）
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
