FROM node:16-alpine as build-stage
WORKDIR /app
COPY package.json  /app/
RUN yarn 
COPY . /app/
ENV GENERATE_SOURCEMAP false
RUN yarn add sass-loader
RUN yarn run build
# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginxß
FROM nginx:1.15
COPY --from=build-stage /app/build/ /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80