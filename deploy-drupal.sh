#!/bin/bash
echo Set the name of the new site:
read sitename
echo Your new Drupal site name is $sitename
echo Set the port of the new site:
read port
echo Your new Drupal site name is $port
echo Starting deploy Drupal instance...
sleep 3
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
if cat drupal/service.yml | sed "s/{{sitename}}/$sitename/g" | microk8s.kubectl apply -f -; then
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
