# docker-influxdb
## Docker container for InfluxDB

See https://influxdb.com/docs/v0.9/introduction/overview.html for influxDB documentation

Currently under early development, may not result in a functionnal container.


## Why this image?

I wanted to give access to a clean and well documented InfluxDB container, suitable for docker beginners as well as InfluxDB beginners.

It means this container has:
* a public git repository
* an up to date docker image
* explanations on its structure and how to use


## mountpoints

Usefull mountpoints are:
* __/opt/influxdb/shared/__ - InfluxDB shared files, contains:
    * __/opt/influxdb/shared/config.toml__ - config file
    * __/opt/influxdb/shared/data/__ - data files
* __/var/log__ - log files.
    * __/var/log/supervisor/__ - init system log files, traces container's process start/stop/restart
    * __/var/log/influxdb/__ - influxdb log files


## Ports

Exposed ports are:
* __:8083__ for admin interface
* __:8086__ for API
* __:25826/udp__ for collectd
* __:8090__ and __:8099__ for cluster internals (Protobuf and Raft prococols) - not mandatory


## Included files

* __build.sh__ - Builds a Docker image from the git tree.
* __start.sh__ - Creates and runs your InfluxDB container.
* __Dockerfile__ - The recipe used by docker to create the image.
* __configfiles/__ - Additionnal files required for the image creation.


## First steps

Documentation on how to have a simple graphing setup can be found here:

https://github.com/hervenicol/Graphing-suite/wiki

