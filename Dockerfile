# Use an official lightweight NGINX image
FROM nginx:latest

# Copy static content
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
