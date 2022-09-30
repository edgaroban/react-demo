# Using node:16-alpine base image
FROM node:16-alpine 

# Set /app as the default work directory
WORKDIR /app

# copy package.json to the working directory for packages installation
COPY package.json /app

# instalar yarn
RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y nodejs yarn postgresql-client

# Install npm dependencies
RUN yarn install

# Copy all the project files to the working directory
COPY . .

# Expose the port of your application to bind with the host port
EXPOSE 3000

# run your app
CMD ['yarn', 'run', 'start']