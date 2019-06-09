#!/bin/sh

GROUP_NAME=${GROUP_NAME:-mango-dev}
sed -i "s#mango-dev#$GROUP_NAME#" $HZ_HOME/bin/hazelcast.xml

exec "$@" 
