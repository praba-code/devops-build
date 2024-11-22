# Use the Node.js base image
FROM node:16

# Set the working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the application code
COPY . .

# Expose port 80
EXPOSE 80

# Start the application
CMD ["npm", "start"]

