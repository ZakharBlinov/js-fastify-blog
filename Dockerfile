FROM node:20-alpine

RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    sqlite-dev

WORKDIR /app

COPY package*.json ./
COPY Makefile ./

RUN npm ci

COPY . .

RUN make build

EXPOSE 8080

CMD ["make", "start"]