# Drupal Builder for Kubernetes

A simple Drupal 8 site builder for Kubernetes

## Disclaimer

Deployment is current set to DEV environment, so if you are planning to use that on PRODUCTION environment, please check the YAML files and make the necessary changes

## Requirements

### MicroK8s

I am using Microk8s for local Kubernetes environement. The YAML files should with all kind of K8s clusters, but scripts were made with microk8s.kubectl command.

To install Microk8s on your local environemt, please check: https://microk8s.io/

Modules enabled:

+ CoreDNS
+ ha-cluster

### Kubernetes API

All APIs listed here. Kubernetes version is 1.22

https://kubernetes.io/docs/concepts/overview/kubernetes-api/

drupal/deployment.yml:apiVersion: apps/v1
drupal/storage.yml:apiVersion: v1
drupal/storage.yml:apiVersion: v1
drupal/namespace.yml:apiVersion: v1
drupal/service.yml:apiVersion: v1
mysql/deployment.yml:apiVersion: apps/v1
mysql/storage.yml:apiVersion: v1
mysql/storage.yml:apiVersion: v1
mysql/namespace.yml:apiVersion: v1
mysql/service.yml:apiVersion: v1

### Storage

For this DEV environment, I am using local storage for PersistentVolumes, so no need of Storage Class. Please, don't use that in PRODUCTION.

To check Storage Classes, please see the following doc: https://kubernetes.io/docs/concepts/storage/storage-classes/#local

## Deploy Drupal Steps

With Microk8s (or any other K8s cluster running), just run the following script file.

> deploy-drupal.sh

It will do the following tasks:

- Site name (it will be the namespace on K8s and also your deployment main name);
- Port for Drupal (mapped local port for HTTP. Only for DEV);
- Deploy MySQL pod with some default settings;
- Deploy Drupal 8.6

## Versions

|Name |Version Number|
|-----|--------|
|K8s  | 1.22    |
|Drupal | 8.6   |
|MySQL | 5.7.38 |

## Remove Drupal

Just run the removal script for completely remove Drupal from your cluster. Just point to the correct sitename/namespace

> remove-drupal.sh

DISCLAIMER: In my lab, I have put the local files on /storage path. If you are using a different path, please change this script.

## Contributing

If you want to contribute with this REPO somehow, please submit a pull request and I will kindly evaluate.