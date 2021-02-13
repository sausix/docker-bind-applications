# docker-bind-applications

Applications for base Docker image with BIND 9 DNS server: https://hub.docker.com/r/sausix/bind-sql-base-alpine

Based on BIND 9 project of Internet Systems Consortium (https://www.isc.org/bind/)

## Applications

### Sample: [primary](primary)
Simple container with static configuration for primary nameservers.

### Sample: [secondary](secondary)
Simple container with static configuration for secondary (slave mode) nameservers.

### Sample: secondary-auto

Simple container with dynamic configuration for secondary (slave mode) nameservers.

Config is generated by environment variables:

```yaml
environment:
	PRIMARY=192.168.16.10
	# or multiple: PRIMARY=192.168.16.10,192.168.16.20
	PRIMARY_ZONES=example.com,example2.com
```

### Sample: primary-sql
**Work in progress**

Application with MariaDB (MySQL) interface as DNS data source.

Requires a connection (or socket) to a working SQL server.

### Sample: primary-sql-with-db
**Work in progress**

Full application with MariaDB (MySQL) server instance and SQL configuration.

### Sample: primary-sql-complete
**Work in progress**

Full framework with MariaDB (MySQL) server instance, SQL configuration and admin webinterface to manage all DNS zones.

## Common configuration
Create your own container from a specific application.

Copy a subfolder to your server (or clone everything).

Enter the directory.

Modify `docker-compose.yml` as you need.

You may bind your DNS service to your public interfaces only if you like.

Add/modify environment variables to modify your container's behaviour.

To create and run the container: (`sudo`) `docker-compose up -d`

To stop and remove the container: (`sudo`) `docker-compose down`


## Volumes
`/etc/bind`

May be used directly for custom configs.

If init scripts present, they could modify files in this location.

May be mounted as tmpfs if there is no persistent data and config gets generated by init scripts completely.

`/var/named`

May be used directly for custom zone data.

If init scripts present, they could modify files in this location.

May be mounted as tmpfs if there is no persistent data and config gets generated by init scripts completely.


## Config mounts
### Container init scripts (init.d/)
Scripts may be provided for tasks in each application before BIND 9 service starts.

Must/may be mounted as needed from within a directory into `/container/init.d/`. Should be mounted read only.


### Config source files (bind-config/)
Some config source files may be provided as static config and for copy operations.

Must/may be mounted as needed from within a directory into `/container/bind-config`. Should be mounted read only.


## Sample init-scripts

**10-apply-config.sh**

Copies file to locations if present in `/container/bind-config`.

| Mounted source | Destination |
|---|---|
| `/container/bind-config/*.conf` | `/etc/bind/` |
| `/container/bind-config/*.key*` | `/etc/bind/` |
| `/container/default-zones/*.zone` | `/var/named/` |
| `/container/bind-config/*.zone` | `/var/named/` |


Environment variables:

| ENV | Description | Values |
|---|---|---|
| `${APPLY_CONFIG}` | Enables this script | `yes`(default) or `no` |
| `${APPLY_VAR_CLEAN}"` | Clears `/var/named` before further init operations | `yes` or `no`(default) |
| `${APPLY_CONFIG_CLEAN}` | Clears `/etc/bind` before further operations | `yes`(default) or `no` |


**15-generate-zones-from-env.sh**

Generates secondary zone definitions from environment variables into `/etc/bind/named.local-gen.conf`

Environment variables:

| ENV | Description | Values |
|---|---|---|
| `${GENERATE_ZONES}` | Enables this script | `yes`(default) or `no` |
| `${PRIMARY}"` | Primary server's ip addresses, seperated by comma | eg. `10.10.10.10` or `10.10.10.10,10.10.10.20` |
| `${PRIMARY_ZONES}` | Comma seperated list of zones | eg. `example.com,example2.com` |


**20-check-bind-keys.sh**

Acquires bind.keys file.

Environment variables:

| ENV | Values |
|---|---|
| `${BIND_KEYS_ACQUIRE}` | `yes` or `no` or *anything* (default) for automatic creation if missing |
| `${BIND_KEYS_FILE}` | `/etc/bind/bind.keys` (default if not set) |
| `${BIND_KEYS_URL` | `https://ftp.isc.org/isc/bind9/keys/9.11/bind.keys.v9_11` (default if not set) |


**30-create-rndc-key.sh**

Creates rndc key and configuration files

| ENV | Values |
|---|---|
| `${RNDC_KEY_GENERATE}` | `yes` (overwrite) or `no` or *anything* for automatic creation if missing |
| `${RNDC_CONF_CREATE}` | `yes` or `no`(default). This config file is redundant with default config for rndc program. |


**50-fix-permissions.sh**

Corrects filesystem permissions of bind files.

Environment variables:

| ENV | Values |
|---|---|
| `${BIND_FIX_PERMISSIONS}` | `yes`(default) or `no`|
