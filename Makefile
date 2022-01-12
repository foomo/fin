docker.build:
	docker build -t foomo/fin:latest .

helm.apply:
	helm upgrade --install fin helm/fin