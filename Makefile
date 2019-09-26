IMAGE_NAME=demo-api-random
IMAGE_VERSION=0.1.0

all: kube-deploy
.PHONY: all pre-commit requirements.txt run-local Dockerfile docker-run docker-stop docker-start docker-delete docker-logs docker-clean kube-deploy kube-apply kube-clean cleanall
.DEFAULT: all

run-local:
	pipenv run flask run

requirements.txt:
	pipenv install
	pipenv sync
	pipenv check
	pipenv lock -r >requirements.txt

Dockerfile: requirements.txt
	docker build --tag $(IMAGE_NAME):$(IMAGE_VERSION) .
	docker build --tag $(IMAGE_NAME):latest .

docker-run: Dockerfile
	docker run --detach --name $(IMAGE_NAME) --publish 5000:5000 $(IMAGE_NAME)

docker-stop:
	-docker stop $(IMAGE_NAME)

docker-start:
	docker start $(IMAGE_NAME)

docker-delete: docker-stop
	-docker rm $(IMAGE_NAME)

docker-logs:
	docker logs $(IMAGE_NAME)

docker-clean: docker-delete
	-docker rmi $(IMAGE_NAME):$(IMAGE_VERSION)
	-docker rmi $(IMAGE_NAME)

kube-deploy: Dockerfile
	kubectl create -f .\random-deploy.yaml
	kubectl create -f .\random-svc.yaml

kube-apply:
	kubectl apply -f .\random-deploy.yaml
	kubectl apply -f .\random-svc.yaml

kube-clean:
	-kubectl delete -f .\random-deploy.yaml
	-kubectl delete -f .\random-svc.yaml

cleanall: kube-clean docker-clean
