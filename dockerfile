# Use an official Node.js runtime as a parent image
FROM node:16

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the application code
COPY . .

# Build the application
RUN npm run build

# Set the default port
ENV PORT 80

# Expose port
EXPOSE 80

# Run the application
CMD ["npx", "serve", "-s", "build", "-l", "80"]

