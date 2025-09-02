# ---------- 构建阶段 ----------
FROM node:22-alpine AS build

WORKDIR /app

# 安装依赖
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# 复制项目文件
COPY . .

# 执行构建脚本（包含 Webpack 和 copy_to_dist.sh）
RUN yarn build:production

# ---------- 生产阶段 ----------
FROM nginx:alpine

# 拷贝构建产物到 Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# 可选：SPA 路由支持
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
