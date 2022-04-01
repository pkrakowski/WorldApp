## Overview

*"Simple and Quick" | Deploy all the required components to a single host using Docker Compose.*

##### Pre-deployment requirements:

*- Ensure all the required envs referenced in [*.env.example*](https://github.com/pkrakowski/WorldApp/blob/main/.env.example) are presented.*

___
#### Dev

Creates a local development environment.

- Invoking builds images that utilize Flask development servers and volume mapping for live file updates inside the containers and spins up all the components.

- Database data persists as a volume.

```
docker-compose -f docker-compose.dev.yaml up --build
```

___
#### Local Build and Test

Primarily used to locally build 'prod' images and run tests.

- Invoking builds images that utilize Apache server with wsgi_mod and spins up all the components.

```
docker-compose -f docker-compose.build.yaml up --build
```

___
#### 'Prod'

Used to deploy all the required components using already built images

- Invoking spins up all the components using already built images.

- Database data persists as a volume.

```
docker-compose -f docker-compose.prod.yaml up
```


