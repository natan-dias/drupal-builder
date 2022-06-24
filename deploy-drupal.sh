#!/bin/bash
echo Set the name of the new site:
read sitename
echo Your new Drupal site name is $sitename
echo Set the port of the new site:
read port
echo Your Drupal PORT is $port
echo Starting deploy Drupal instance...
sleep 3
echo ==== Deploy MYSQL Instance Namespace ====
if cat mysql/namespace.yml | sed "s/{{sitename}}/$sitename/g" | microk8s.kubectl apply -f -; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi
sleep 3
echo ==== Deploy MYSQL Instance Storage ====
if cat mysql/storage.yml | sed "s/{{sitename}}/$sitename/g" | microk8s.kubectl apply -f -; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi
sleep 3
echo ==== Deploy MYSQL Instance Service ====
if cat mysql/service.yml | sed "s/{{sitename}}/$sitename/g" | sed "s/{{port}}/$port/g" | microk8s.kubectl apply -f -; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi
sleep 3
echo ==== Deploy MYSQL Instance Deployment ====
if cat mysql/deployment.yml | sed "s/{{sitename}}/$sitename/g" | microk8s.kubectl apply -f -; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi
sleep 3
echo ===== Starting Drupal Deployment =====
echo ==== Deploy Namespace ====
if cat drupal/namespace.yml | sed "s/{{sitename}}/$sitename/g" | microk8s.kubectl apply -f -; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi
sleep 3
echo ==== Deploy Storage ====
if cat drupal/storage.yml | sed "s/{{sitename}}/$sitename/g" | microk8s.kubectl apply -f -; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi
sleep 3
echo ==== Deploy Service ====
if cat drupal/service.yml | sed "s/{{sitename}}/$sitename/g" | sed "s/{{port}}/$port/g" | microk8s.kubectl apply -f -; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi
sleep 3
echo ==== Final Deployment ====
if cat drupal/deployment.yml | sed "s/{{sitename}}/$sitename/g" | microk8s.kubectl apply -f -; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi
