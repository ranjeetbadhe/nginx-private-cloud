FROM nginx:alpine

USER root

# Change nginx to listen on 8080 (non-privileged port) and make cache/log/run dirs writable by any UID in group 0
RUN sed -i 's/listen\s\+80;/listen 8080;/g' /etc/nginx/conf.d/default.conf \
    && mkdir -p /var/cache/nginx/client_temp \
    && chgrp -R 0 /var/cache/nginx /var/run /var/log/nginx \
    && chmod -R g+rwx /var/cache/nginx /var/run /var/log/nginx

# Remove default content (optional)
RUN rm -f /usr/share/nginx/html/*

# Copy your custom index page
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 8080

# Drop to non-root user (works with restricted SCC arbitrary UID logic)
USER 1001

# Run nginx in foreground so container stays alive
CMD ["nginx", "-g", "daemon off;"]

