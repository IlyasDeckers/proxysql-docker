# ProxySQL Docker
This is a container image for ProxySQL. It is meant to run alongside a PerconaXtraDB cluster and etcd. (Image following soon)

## Usage
```shell
docker service create --name mysql_cluster_proxy \
  --network app-network \                               # 
	--network mysql-client \                              # Must be the same network as the database cluster
	-p 3306 -p 6032 \                 
	-e DISCOVERY_SERVICE=10.100.0.11:2379 \               # Etcd discovery service
	-e CLUSTER_NAME=client_mysql \                        # PerconaXtraDB cluster name as registered in etcd
	-e MYSQL_PROXY_USER=proxyuser \                       # ProxySQL username
	-e MYSQL_PROXY_PASSWORD=s3cret \                      # ProxySQL password
	-e MYSQL_ROOT_PASSWORD=password \                     # Database cluster root password
	phasehosting/mysql-proxy
```
When the service is in running state, execute the following command to configure ProxySQL
```shell
docker exec -it <container name> bash add_cluster_nodes.sh
```

You can now connect to the database cluster with from any container that is in you app network (For example a Laravel app)
```shell
mysql -uproxyuser -ps3cret -h mysql_cluster_proxy
```
