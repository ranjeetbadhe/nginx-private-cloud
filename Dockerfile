FROM nginx:alpine

USER root

# Change nginx to listen on 8080 (non-privileged port)
# and make cache/log/run dirs writable by ANY UID (777)
RUN sed -i 's/listen\s\+80;/listen 8080;/g' /etc/nginx/conf.d/default.conf \
    && mkdir -p /var/cache/nginx/client_temp \
    && chmod -R 777 /var/cache/nginx /var/run /var/log/nginx

# Remove default content (optional)
RUN rm -f /usr/share/nginx/html/*

# Copy your custom index page
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 8080

# Let SCC choose a random non-root UID; don't force one
CMD ["nginx", "-g", "daemon off;"]

