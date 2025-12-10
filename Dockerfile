FROM nginx:alpine

# Remove default page (optional)
RUN rm -f /usr/share/nginx/html/*

# Copy your custom index.html
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
