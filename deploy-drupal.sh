#!/bin/bash
echo Set the name of the new site:
read sitename
echo Your new Drupal site name is $sitename
echo Starting deploy Drupal instance...
sleep 3
echo Deploy Namespace
if [cat drupal/namespace.yml | sed "s/{{sitename}}/$sitename/g" | kubectl apply -f -]; then
     echo “Success”
else
     echo “Failure, exit status: $?”
fi

