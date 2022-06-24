#!/bin/bash
echo Set the name of the site you want to remove:
read sitename
echo Your removed Drupal site name is $sitename
echo Set the port of the old site:
read port
echo Your old Drupal PORT is $port
echo Starting deploy Drupal instance...
sleep 3
sleep 3
echo ==== Remove Deployment ====
if cat drupal/deployment.yml | sed "s/{{sitename}}/$sitename/g" | microk8s.kubectl delete -f -; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi
sleep 3
echo ==== Remove Service ====
if cat drupal/service.yml | sed "s/{{sitename}}/$sitename/g" | sed "s/{{port}}/$port/g" | microk8s.kubectl delete -f -; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi
sleep 3
echo ==== Remove Storage ====
if cat drupal/storage.yml | sed "s/{{sitename}}/$sitename/g" | microk8s.kubectl delete -f -; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi
echo ==== Remove Namespace ====
if cat drupal/namespace.yml | sed "s/{{sitename}}/$sitename/g" | microk8s.kubectl delete -f -; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi



