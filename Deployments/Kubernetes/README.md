## Overview

*A collection of YAML templates, Helm Chart and Skaffold config that can be used to easily and reliably deploy the application to the Kubernetes cluster.*

___
#### Regular deployment with NGINX-Ingress

- Deploy NGNIX-Ingress to your cluster

    https://kubernetes.github.io/ingress-nginx/deploy/
    
- Install Helm 

    https://helm.sh/docs/intro/install/
    
- Install WorldApp:
```
helm upgrade --install worldapp worldapp \
--set secret.mysql_root_password=mysqlrootpassword \
--set secret.mysql_user=mysqluser \
--set secret.mysql_password=mysqluserpassword \
--set secret.admin_user=adminuser \
--set secret.admin_password=adminpassword \
--set-file crt=certificate.crt \
--set-file key=private.key \
--values yourvaluesfile
```
Note: If certificate files are omitted deployment will proceed with the default Kubernetes Fake certificate
___
#### AKS deployment with AGIC

If deploying to AKS, AGIC is a possible alternative to NGINX for the Ingress service that allows to leverage Azure's Application Gateway instead.

- Deploy AKS cluster and configure AGIC *(To deploy with Terraform [see here](https://github.com/pkrakowski/WorldApp/tree/main/Deployments/TerraformAKS))*


- Install Helm

    https://helm.sh/docs/intro/install/
       
- Install WorldApp:
```
helm upgrade --install worldapp worldapp \
--set secret.mysql_root_password=mysqlrootpassword \
--set secret.mysql_user=mysqluser \
--set secret.mysql_password=mysqluserpassword \
--set secret.admin_user=adminuser \
--set secret.admin_password=adminpassword \
--values yourvaluesfile
--deployWithAGIC true
```
___
#### Local Dev using Skaffold

Skaffold can help with setting up a dev environment in Kubernetes that can take advantage of live file reloads.

- Install Skaffold on Linux
```
  curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
  sudo install skaffold /usr/local/bin/
``` 
Docs:
https://skaffold.dev/docs/install/

- To start dev environment execute below from root of this project:
```   
  skaffold dev
```
Note: By default, it will try to create and deploy to a separate 'development' namespace. This can be altered on lines 7-8 in [skaffold.yaml](https://github.com/pkrakowski/WorldApp/blob/main/skaffold.yaml)

