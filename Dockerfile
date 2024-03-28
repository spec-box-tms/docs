FROM nginx

EXPOSE 80
EXPOSE 443

COPY 1-generate-configs.sh /docker-entrypoint.d/
