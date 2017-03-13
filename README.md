# ProxySQL Docker
This is a container image for ProxySQL. It is meant to run alongside a PerconaXtraDB cluster and etcd. (Image following soon)

## Usage
To start ProxySQL you will need PerconaXtraDB and etcd up and running on docker swarm. This images creates a proxy service to distribute requests to a database cluster.

There are some scripts that you can run to provision you databases without loggin in to them.

### Start the service

```shell
docker service create --name mysql_cluster_proxy \
  --network app-network \                               # 
	--network mysql-client \                              # Must be the same network as the database cluster
	--mount type=volume,source=proxysql,target=/var/backup
	-p 3306 -p 6032 \                 
	-e DISCOVERY_SERVICE=10.100.0.11:2379 \               # Etcd discovery service
	-e CLUSTER_NAME=client_mysql \                        # PerconaXtraDB cluster name as registered in etcd
	-e MYSQL_PROXY_USER=proxyuser \                       # Superuser username
	-e MYSQL_PROXY_PASSWORD=s3cret \                      # Superuser password
	-e MYSQL_ROOT_PASSWORD=password \                     # Database cluster root password
	phasehosting/mysql-proxy
```

The service watches for changes in the database cluster and removes dead nodes from the proxy automatically.

I strongly advise to set the followin variables to something uncommon, these credentials are for the superuser and it can connect to every database.

```
	-e MYSQL_PROXY_USER=proxyuser \                       # Superuser username
	-e MYSQL_PROXY_PASSWORD=s3cret \                      # Superuser password

```
### Create database
(Comming Soon)

### Create a database user

To add a new user and restrict access to a database execute the following command:
```shell
docker exec -it <container> bash add_user <database> <user> <password>
```

### Automatic backups
The proxy creates backup automatically every 60 min and get retained for 30 days. It is advised to mount a volume to `/var/backup` for not losing backups when the container gets deleted. Soon, S3 will be added as a storage backend for the backups.

### Environment variables

```
MYSQL_PROXY_SUPERUSER
MYSQL_PROXY_PASSWORD
DISCOVERY_SERVICE
CLUSTER_NAME

# optional
S3KEY
S3SECRET
S3BUCKET

PROXY_ADMIN_PORT
PROXY_ADMIN_USER
PROXY_ADMIN_PASS
```

## Custom scripts
You can put custom scripts in the bin folder, they will automatically be copied to `/user/bin` when building the image. This can make common administrative tasks easy and fast.
