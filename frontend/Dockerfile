# SET BASE IMAGE
FROM node:22-slim

# SET WORKDIR IN CONTAINER
WORKDIR /weatherapp/frontend

# COPY package.json and package-lock.json to work directory
COPY package.json package-lock.json ./

# INSTALL DEPENDENCIES
RUN npm install

# COPY SOURCE FILES
COPY . .

# EXPOSE PORT
EXPOSE 8000

# COMMAND TO RUN AFTER STARTING THE CONTAINER
CMD ["npm", "start"]
