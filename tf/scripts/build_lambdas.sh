#!/bin/bash

lambdas=("clone-repo")
path_module=$(pwd)

for lambda in "${lambdas[@]}"
do
  echo "Building $lambda"

  cd $path_module/../microservices/$lambda
  rm -rf python
  mkdir python
  pip3 install -r requirements.txt -t python/
  rsync -ax --exclude 'python' . python

  mkdir -p $path_module/../microservices/tmp
  cd python
  zip -r $path_module/../microservices/tmp/$lambda.zip .

  echo "Built $lambda"
done
