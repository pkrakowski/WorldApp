#  WorldApp and DevOps

*WorldApp started as a simple project to play with Python and Flask web development but eventually became a base for trialling different DevOps tools, technologies and processes.*

![Alt text](https://github.com/pkrakowski/WorldApp/blob/main/demo.JPG?raw=true "Title")


#### This repository holds source files for a simple web app which consists of three microservices as well as instructions and config files for deploying it and other required components to different environments using multiple methods and tools. It mostly serves as my "Here's a quick reminder" repo but if someone stumbles upon it feel free to use it as an inspiration and a starting point for building your own flows.

##### 1. [Deploy directly to VMs. IaC with Terraform and Ansible (Non-contenerized deployment)](https://github.com/pkrakowski/WorldApp/tree/main/Deployments/VMs/direct)

##### 2. [Deploy to a single host with Docker Compose](https://github.com/pkrakowski/WorldApp/tree/main/Deployments/Compose)

##### 3. [Deploy to a Kubernetes cluster with Helm](https://github.com/pkrakowski/WorldApp/tree/main/Deployments/Kubernetes)

##### 4. [Deploy to AKS through a complete Azure DevOps YAML pipeline](https://github.com/pkrakowski/WorldApp/blob/main/aks-azure-pipeline.yml)


```
    ------- STAGES ----------------------------------------------------------------------------------------------------------------------------
    1)      Build:      On commit to trunk builds and pushes new Docker images to the repository. Images are tagged with commit ID which is used by all the later stages and allows for a quick codebase identification in case of any issues.
    2)      TEST:       Installs and configures Minikube on the Agent, deploys images and runs Integration tests.
    3)      QA:         Deploys new version of Docker images to QA, if any changes to the Terraform config were made updates AKS QA* infrastructure prior.
    4)      planPROD:   Creates Terraform Plan for any changes to the PROD infrastructure.
    5)      PROD:       (On Approval): Deploys a new version of Docker images to PROD, if any changes to Terraform config were made updates AKS PROD* infrastructure with the prior approved Plan.

    *QA and PROD AKS environments utilize AGIC instead of NGINX Ingress and are built with the exact same Terraform config.
```
Terraform configs for deploying AKS cluster can be found [in this folder](https://github.com/pkrakowski/WorldApp/tree/main/Deployments/TerraformAKS)

In general, each deployment variation will spin up a

- *Load Balancer / Reverse Proxy*

- *API, Client and Admin microservices*

- *MySQL instance*

- *Redis instance for caching*

___
### High-level overview of the repo:

    .
    ├── Deployments                     # Instructions and config files for all the different deployment methods and flows
    ├── api                             # Source files and Docker files for Api microservice
    ├── client                          # Source files and Docker files for Client microservice
    ├── admin                           # Source files and Docker files for Admin microservice with Basic Login
    ├── admin_b2c                       # Source files and Docker files for Admin microservice with Azure B2C Login integration
    ├── env.example                     # List of all the required envs for each of the components
    ├── Countries.csv                   # Sample data
    └── ...
___
### Microservices

- API:

*Database access API, retrieves detail about a queried country from the database, caches the result in Redis and returns JSON response. Can be exposed to end-users or run as local only API.*

    PATHS:
    -----------------------------------------------------------------
    GET /all                - Returns a list of all the countries
    GET /{country_name}     - Returns details about a specified country

- Client:

*Client component which calls API on the user's behalf, parses the JSON response and presents it back in a user-friendly format.*

- Admin:

*Imitates a secure administrative portal, current iteration can be used to insert sample data into the database. If exposed to the Internet consider locking down access to only specified endpoints.* **_Once the deployment completes, use it to load sample data (usually accessible under '/admin/' path)_**

- Admin B2C

*Alternative to Admin service which uses Azure B2C for authentication. Requires additional setup described [here](https://github.com/pkrakowski/WorldApp/blob/main/admin_b2c/README.md)*

___
