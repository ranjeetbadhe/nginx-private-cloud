FROM nginx:alpine

# Change nginx to listen on 8080 instead of 80 (non-privileged port)
RUN sed -i 's/listen\s\+80;/listen 8080;/g' /etc/nginx/conf.d/default.conf \
    && mkdir -p /var/cache/nginx/client_temp \
    && chmod -R 777 /var/cache/nginx

# Remove default content (optional)
RUN rm -f /usr/share/nginx/html/*

# Copy custom index page
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 8080

# Run nginx in foreground so container stays alive
CMD ["nginx", "-g", "daemon off;"]

