# Makefile
.PHONY: dev test build clean help

IMAGE = sentiment-ai
TAG = v0.1.0

help: ## Afficher l'aide
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS=":.*?## "}; {printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}'

dev: ## Démarrer la stack (mode dev)
	docker compose up --build -d

down: ## Arrêter la stack
	docker compose down

test: ## Lancer les tests
	docker run --rm $(IMAGE):$(TAG) pytest tests/ -v

build: ## Construire l'image Docker
	docker build -t $(IMAGE):$(TAG) .

clean: ## Nettoyer
	docker compose down -v
	docker rmi $(IMAGE):$(TAG) 2>/dev/null || true

jenkins-run: ## Lancer Jenkins
	docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkins/jenkins:lts