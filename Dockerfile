FROM node:20-alpine AS assets-builder
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY tailwind.config.js ./
COPY static ./static
COPY home ./home
COPY jobs ./jobs

RUN npm run build:css


FROM python:3.11-slim
WORKDIR /app

RUN pip install --upgrade pip

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
COPY --from=assets-builder /app/static/dist/ /app/static/dist/

RUN chmod +x /app/entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]
