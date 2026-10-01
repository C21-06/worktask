.PHONY: up down logs test

up:
	@if [ ! -f .env ]; then cp .env.example .env; echo "Created .env from .env.example"; fi
	docker-compose up -d
	@echo "Waiting for containers to become healthy..."
	@sleep 8
	@docker-compose ps

down:
	docker-compose down -v

logs:
	docker-compose logs -f --tail=200

test:
	@echo "=== Healthcheck ==="
	curl -s http://localhost:8080/healthz | jq .
	@echo ""
	@echo "=== X-Request-ID header ==="
	curl -si http://localhost:8080/healthz | grep -i x-request-id
	@echo ""
	@echo "=== Flood test (expect some 429s) ==="
	@for i in $$(seq 1 20); do curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8080/healthz; done | sort | uniq -c
