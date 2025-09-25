# Use official nginx image as base
FROM nginx:1.25-alpine

# Install curl for health check (optional)
RUN apk add --no-cache curl

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy our HTML application to nginx directory
COPY index.html /usr/share/nginx/html/

# Copy custom nginx configuration (optional)
//COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Health check to ensure nginx is running
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
