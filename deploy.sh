#!/bin/bash

SPRINGACADEMY_VERSION=$1

jekyll build
docker build -t ctsc/spring.academy:$SPRINGACADEMY_VERSION .
docker tag ctsc/spring.academy:$SPRINGACADEMY_VERSION ctsc/spring.academy:latest
docker push ctsc/spring.academy:$SPRINGACADEMY_VERSION
docker push ctsc/spring.academy:latest
kubectl config set-context do-fra1-cluster-k8s-tsc
cat .release/spring-academy/Chart-template.yaml | sed "s/appVersion: latest/appVersion: $SPRINGACADEMY_VERSION/" > .release/spring-academy/Chart.yaml
helm upgrade website-test .release/spring-academy
helm list
git add .
git commit -m "Version $SPRINGACADEMY_VERSION"
git tag $SPRINGACADEMY_VERSION
git push origin --all
git push origin --tags
