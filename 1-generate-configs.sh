#!/bin/bash
mkdir -p /etc/nginx/templates/

cat <<EOF > /etc/nginx/templates/default.conf.template
server {
    listen 80;
    port_in_redirect off;

    location / {
        proxy_pass http://\${WEB_HOST}:\${WEB_PORT};
    }

    location /api {
        proxy_pass http://\${API_HOST}:\${API_PORT};
    }

    client_max_body_size 32M;
}
EOF

if [ "$ENABLE_HTTPS" == "true" ]; then
  if [[ -z "${SSL_KEY}" ]]; then
    echo "Error: SSL_KEY is not defined but ENABLE_HTTPS is true"
    exit 1
  fi
  if [[ -z "${SSL_CERT}" ]]; then
    echo "Error: SSL_CERT is not defined but ENABLE_HTTPS is true"
    exit 1
  fi

echo "${SSL_CERT}" > /etc/nginx/nginx.crt
echo "${SSL_KEY}" > /etc/nginx/nginx.key

cat <<EOF > /etc/nginx/templates/https.conf.template
server {
    listen 443 ssl;
    port_in_redirect off;

    ssl_certificate     /etc/nginx/nginx.crt;
    ssl_certificate_key /etc/nginx/nginx.key;

    location / {
        proxy_pass http://\${WEB_HOST}:\${WEB_PORT};
    }

    location /api {
        proxy_pass http://\${API_HOST}:\${API_PORT};
    }

    client_max_body_size 32M;
}
EOF
fi
