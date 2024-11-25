# Use the official Node.js image
FROM node:16-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Expose port 80
EXPOSE 80

# Command to serve the app using a simple HTTP server
CMD ["npx", "serve", "build", "-l", "80"]

