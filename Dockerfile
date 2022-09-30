# Using node:16-alpine base image
FROM node:16-alpine 

# Set /app as the default work directory
WORKDIR /app

# copy package.json to the working directory for packages installation
COPY package.json /app

# instalar yarn
 RUN apk add yarn --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ && \
  yarn install && \
  apk del yarn


# Install npm dependencies
RUN yarn install

# Copy all the project files to the working directory
COPY . .

# Expose the port of your application to bind with the host port
EXPOSE 3000

# run your app
CMD ['yarn', 'run', 'start']