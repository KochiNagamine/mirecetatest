FROM node:16-alpine as build

WORKDIR /usr/local/app

COPY package*.json /usr/local/app/

RUN npm ci

COPY . /usr/local/app/
RUN npm run build --prod

# Stage 2: Serve app with nginx server

# Use official nginx image as the base image
FROM nginx:stable-alpine

RUN rm -rf /usr/share/nginx/html/*
# Copy the build output to replace the default nginx contents.
COPY --from=build /usr/local/app/dist/mireceta-web /usr/share/nginx/html

# Expose port 80
EXPOSE 80