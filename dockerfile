# Step 1: Use Node.js as the base image
FROM node:16

# Step 2: Set the working directory
WORKDIR /app

# Step 3: Copy package.json and install dependencies
COPY package.json ./
RUN npm install

# Step 4: Copy the entire app code
COPY . .

# Step 5: Build the app
RUN npm run build

# Step 6: Expose port 80 for HTTP traffic
EXPOSE 80

# Step 7: Run the app
CMD ["npm", "start"]

