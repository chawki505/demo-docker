# Préparation de l'hôte sous debian

## Installation des dependances

### Docker

- source : https://docs.docker.com/engine/install/

#### Configurer repository

```bash
$ sudo apt-get update

$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

$ curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
```

#### Installer docker engine

```bash
$ sudo apt-get update
$ sudo apt-get install docker-ce docker-ce-cli containerd.io
$ sudo docker --version
Docker version 20.10.2, build 2291f61
```

#### Configurer Docker en non-root user

```bash
$ sudo groupadd docker
$ sudo usermod -aG docker $USER
$ newgrp docker
$ sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
$ sudo chmod g+rwx "$HOME/.docker" -R
$ docker --version
Docker version 20.10.2, build 2291f61
```


### Docker-Compose

- source : https://docs.docker.com/compose/install/

#### Installer Docker-Compose

```bash
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

$ sudo chmod +x /usr/local/bin/docker-compose

$ docker-compose --version
docker-compose version 1.28.2, build 67630359
```

### BtrFS

#### Installer btrfs-tools

```bash
$ sudo apt install btrfs-tools
$ btrfs --version
btrfs-progs v4.20.1
```

## Formatage

```bash
$ file /dev/disk/by-id/*
liste des volumes disponible
$ sudo mkfs.btrfs -f /dev/disk/by-id/VOTRE_VOLUME_SECONDAIRE
```

## Montage temporaire du volume
```bash
$ sudo mkdir /mnt/btrfs
$ sudo mount -o defaults,discard /dev/disk/by-id/VOTRE_VOLUME_SECONDAIRE /mnt/btrfs/
$ sudo chown -R $(whoami): /mnt/btrfs
```

## Test avec un fichier
```bash
$ df -h -x tmpfs -x devtmpfs
$ echo "success"  | sudo tee /mnt/btrfs/test
$ cat /mnt/btrfs/test
$ rm -f /mnt/btrfs/test
```

## Clonage du projet

```bash
$ git clone https://github.com/chawki505/demo-docker
```

## Construire les images Jenkins avec support BtrFS

```bash
$ cd demo-docker
$ groupadd -g 1000 jenkins
$ useradd -g jenkins jenkins
$ docker build --build-arg GID=1000 -t treeptik/jenkins jenkins
```

## Lancement des applications docker

```bash
$ ./startup.sh
```

## Configuration GitLab & Jenkins

Il faut créer un projet dans le GitLab docker qui sera issue du projet GitHub public.
Egalement créer un job multibuild pipeline basé sur le projet github.

# Préparer les données

## Création des données de référence

```bash
$ mkdir /mnt/btrfs/pg-data-ref
```

## Lancer le container pour provisionner les données

```bash
$ docker run --name postgres-srv \
   -e POSTGRES_PASSWORD=mysecretpassword \
   -v /mnt/btrfs/pg-data:/var/lib/postgresql/data \
   -v `pwd`/scripts/users.sql:/opt/scripts/users.sql \
   -d postgres

$ docker exec -it postgres-srv bash

container> psql -U postgres
    postgres> \timing
    postgres> \i /opt/scripts/users.sql
```

## Création du volume BtrFS

```bash
btrfs subvolume create /mnt/btrfs/pg-data-ref
sudo chown -R jenkins:jenkins /mnt/btrfs/pg-data-ref/
```
