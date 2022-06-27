#!/bin/bash
echo === Deploy Drupal and MySQL ===
echo Set the name of the new site:

read sitename

echo Your new Drupal site name is $sitename

echo Set the port of the new site:

read port

echo Your Drupal PORT is $port

echo Creating random MySQL Password

password=$(openssl rand -base64 16)

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
if cat mysql/service.yml | sed "s/{{sitename}}/$sitename/g" | microk8s.kubectl apply -f -; then
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
echo ===== Deploy Namespace =====
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

echo Checking current deployment information
microk8s.kubectl get pod -n $sitename -o wide

microk8s.kubectl get svc -n $sitename -o wide

microk8s.kubectl get pvc -n $sitename -o wide

echo ===== DATABASE INFORMATION FOR DRUPAL SETUP =====
DATABASE_NAME=$(microk8s.kubectl get deploy $sitename-mysql -n $sitename -o jsonpath='{.spec.template.spec.containers[*].env[1].value}')
#PASSWORD=$(microk8s.kubectl get deploy $sitename-mysql -n $sitename -o jsonpath='{.spec.template.spec.containers[*].env[0].value}')
MYSQL_PASSWORD=$(microk8s.kubectl get deploy $sitename-mysql -n $sitename -o jsonpath='{.spec.template.spec.containers[*].env[0].value}')
SERVICE_HOST_NAME=$(microk8s.kubectl get svc -n $sitename -o jsonpath='{.items[1].metadata.name}')
MYSQL_PORT=$(microk8s.kubectl get svc $sitename-mysql-service -n $sitename -o jsonpath='{.spec.ports[*].port}')

echo Database Name is $DATABASE_NAME
echo Password is $MYSQL_PASSWORD
echo Host MySQL is $SERVICE_HOST_NAME
echo MySQL Port is $MYSQL_PORT