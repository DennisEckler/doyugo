FROM node:22-alpine AS build

RUN npm install -g @angular/cli@19

WORKDIR /app

COPY ./ /app/

RUN npm install

RUN ng build --configuration production


# Stage 2: Serve app with nginx server
FROM nginx:1.27.3

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build /app/dist/doyugo/browser /usr/share/nginx/html

RUN mkdir /etc/nginx/certs && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/server.key -out /etc/nginx/certs/server.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=localhost"

EXPOSE 443
