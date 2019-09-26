IMAGE_NAME=demo-api-random
IMAGE_VERSION=0.3.0
DEPLOY_REPO=docker.pkg.github.com/dedickinson/demo-api-random

all: kube-deploy
.PHONY: all pre-commit run-local release Dockerfile docker-run docker-stop docker-start docker-delete docker-logs docker-clean kube-deploy kube-apply kube-clean cleanall
.DEFAULT: all

run-local:
	pipenv run flask run

Dockerfile:
	docker build --tag $(IMAGE_NAME) .
	docker tag $(IMAGE_NAME):latest $(IMAGE_NAME):$(IMAGE_VERSION)

release:
	pipenv sync
	pipenv check
	docker build --tag $(DEPLOY_REPO)/$(IMAGE_NAME):$(IMAGE_VERSION) .

	git tag $(IMAGE_VERSION)
	docker push $(DEPLOY_REPO)/$(IMAGE_NAME):$(IMAGE_VERSION)
	git push origin $(IMAGE_VERSION)

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
