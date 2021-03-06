#!/bin/bash
set -e 
echo === Remove Drupal and MySQL ===
echo Set the name of the site you want to remove:

read sitename

# TEST EXISTING NAMESPACE

if microk8s.kubectl describe ns $sitename | grep Status; then
     echo Your removed Drupal site name is $sitename
else
     echo Site Not Found! Nothing will be removed, exit status: $?
fi

port=$(microk8s.kubectl get svc $sitename-service -n $sitename -o jsonpath='{.spec.ports[*].port}')

echo Your old Drupal PORT is $port

echo Starting remove Drupal old instance...
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
sleep 3

echo ==== Removing MYSQL Instance ====
if cat mysql/deployment.yml | sed "s/{{sitename}}/$sitename/g" | microk8s.kubectl delete -f -; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi
sleep 3

echo ==== Remove Service ====
if cat mysql/service.yml | sed "s/{{sitename}}/$sitename/g" | microk8s.kubectl delete -f -; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi
sleep 3

echo ==== Remove Storage ====
if cat mysql/storage.yml | sed "s/{{sitename}}/$sitename/g" | microk8s.kubectl delete -f -; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi
sleep 3

echo ==== Remove Namespace ====
if cat mysql/namespace.yml | sed "s/{{sitename}}/$sitename/g" | microk8s.kubectl delete -f -; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi

# Removing local files
echo Removing files... # Just for lab 
sudo rm -rf /storage/$sitename-filestore/
sudo rm -rf /storage/$sitename-mysql-filestore/