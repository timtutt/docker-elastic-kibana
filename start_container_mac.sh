ip=`docker-machine ip $1`
docker run -p $ip:202:22 -p $ip:9200:9200 -p $ip:5601:5601 -p $ip:9300:9300 -d $2
