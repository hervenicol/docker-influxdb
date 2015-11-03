# Based on a light and trusted image
FROM debian:wheezy

MAINTAINER Herve Nicol

# Make sure system image is up to date
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq

# Install required applications:
#	supervisor, used to start our application(s)
#	wget, to get the influxdb archive
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq \
	--no-install-recommends \
	supervisor wget

# InfluxDB install
ADD http://s3.amazonaws.com/influxdb/influxdb_0.9.4.2_amd64.deb /tmp/influxdb.deb 
RUN dpkg -i /tmp/influxdb.deb && \
rm /tmp/influxdb.deb



#### Enable collectd

# delete "collectd" section
# and add our own section
RUN sed -i -n -e '/./{H;$!d}' -e 'x;/\[collectd\]/!p' /etc/opt/influxdb/influxdb.conf && \
echo '\n\
###\n\
### [collectd]\n\
###\n\
### Controls the listener for collectd data.\n\
###\n\
\n\
[collectd]\n\
  enabled = true\n\
  bind-address = ":25826"\n\
  database = "collectd"\n\
  typesdb = "/etc/opt/influxdb/collectd_types.db"\n\
' >> /etc/opt/influxdb/influxdb.conf

# Retrieve the types.db file
ADD https://raw.githubusercontent.com/collectd/collectd/master/src/types.db /etc/opt/influxdb/collectd_types.db

#### Collectd connector setup done


# supervisord configuration
RUN sed -i -e 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf
ADD configfiles/supervisor-influxdb.conf /etc/supervisor/conf.d/influxdb.conf

# expose the InfluxDB daemon ports
EXPOSE 8083 8086 8090 8099 25826

# Default run command, supervisord, which starts our app(s)
CMD /usr/bin/supervisord

