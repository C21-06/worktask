# DevOps Task

Мінімальний веб-сервіс за nginx реверс проксі, з рейт лімітингом і X-Request-ID трейсингом.

## Що треба

- Docker + Docker Compose
- jq
- Бонус: kind, kubectl, helm

## Як запустити

    cp .env.example .env
    make up
    make test
    make logs
    make down

## Що має вийти

Хелсчек: curl -s http://localhost:8080/healthz
Відповідь: {"status":"ok","service":"app","env":"local"}

Флад тест 20 запитів — частина поверне 429.

## Що реалізовано

- Реверс проксі — nginx:8080 проксює до апки
- Рейт лімітинг — 10 req/s, при перевищенні 429
- X-Request-ID — nginx генерує якщо клієнт не передав
- Хелсчеки — проксі стартує тільки після healthy апки

## Бонус: Kubernetes

    kind create cluster --name devops-task
    helm install ingress-nginx ingress-nginx/ingress-nginx ...
    kubectl apply -f k8s/
    curl http://localhost/healthz
    kind delete cluster --name devops-task
