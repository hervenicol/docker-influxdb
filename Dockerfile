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

# supervisord configuration
RUN sed -i -e 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf
ADD configfiles/supervisor-influxdb.conf /etc/supervisor/conf.d/influxdb.conf

# expose the InfluxDB daemon ports
EXPOSE 8083 8086 8090 8099

# Default run command, supervisord, which starts our app(s)
CMD /usr/bin/supervisord

