# Используем официальный образ Node.js версии 20
FROM node:20-alpine

# Устанавливаем необходимые зависимости для сборки нативных модулей
RUN apk add --no-cache \
    python3 \
    py3-setuptools \
    make \
    g++ \
    sqlite-dev

# Создаем симлинк для python3 (чтобы был доступен как python)
RUN ln -sf python3 /usr/bin/python

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем файлы для установки зависимостей
COPY package*.json ./
COPY Makefile ./

# Обновляем npm и устанавливаем зависимости
RUN npm install -g npm@latest && \
    npm ci

# Копируем весь исходный код
COPY . .

# Собираем статические ассеты (webpack)
RUN make build

# Указываем порт, который слушает приложение (по умолчанию 8080)
EXPOSE 8080

# Запускаем приложение в режиме production
CMD ["make", "start"]