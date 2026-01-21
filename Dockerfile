# Use the official Node.js image
FROM node:18

# Set the working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package.json ./
RUN npm install

# Copy all source code
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Start the app
CMD ["node", "app.js"]
