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
RUN wget http://influxdb.s3.amazonaws.com/influxdb_0.8.8_amd64.deb -O /tmp/influxdb.deb && \
	dpkg -i /tmp/influxdb.deb && \
rm /tmp/influxdb.deb

# Customize log path to /var/log/influxdb/
RUN mkdir /var/log/influxdb && \
	chown influxdb:influxdb /var/log/influxdb
RUN sed -i -e 's/^file *= \".*\"/file = \"\/var\/log\/influxdb\/log.txt\"/g' /opt/influxdb/shared/config.toml



#### Enable collectd

# delete "input_plugins.collectd" section
RUN sed -i -n -e '/./{H;$!d}' -e 'x;/\[input_plugins.collectd\]/!p' /opt/influxdb/shared/config.toml

# Add our own section
RUN sed -i 's/\[input_plugins\]/\
\[input_plugins\]\n\
  \# Configure the collectd api\n\
  \[input_plugins.collectd\]\n\
  enabled = true\n\
  \# address = "0.0.0.0" # If not set, is actually set to bind-address.\n\
  port = 25826\n\
  database = "collectd"\n\
  \# types.db can be found in a collectd installation or on github:\n\
  \# https:\/\/github.com\/collectd\/collectd\/blob\/master\/src\/types.db\n\
  typesdb = "\/opt\/influxdb\/shared\/collectd_types.db" # The path to the collectd types.db file\n\
/g' /opt/influxdb/shared/config.toml

# Retrieve the types.db file
RUN wget --no-check-certificate -O /opt/influxdb/shared/collectd_types.db https://raw.githubusercontent.com/collectd/collectd/master/src/types.db

#### Collectd connector setup done


# supervisord configuration
RUN sed -i -e 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf
ADD configfiles/supervisor-influxdb.conf /etc/supervisor/conf.d/influxdb.conf

# expose the InfluxDB daemon ports
EXPOSE 8083 8086 8090 8099 25826

# Default run command, supervisord, which starts our app(s)
CMD /usr/bin/supervisord

