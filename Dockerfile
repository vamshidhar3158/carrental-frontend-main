# Stage 1: build
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci            # or npm install if you prefer
COPY . .
RUN npm run build     # produces ./build (for CRA) or ./dist (for some setups)

# Stage 2: serve with nginx
FROM nginx:stable-alpine
# Remove default nginx config if you will replace it
RUN rm -f /etc/nginx/conf.d/default.conf
# Copy our custom nginx config (optional) or use default & copy files into /usr/share/nginx/html
COPY --from=build /app/build /usr/share/nginx/html
# Expose port 80
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
