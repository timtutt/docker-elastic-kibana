# docker-elastic-kibana
Docker instance with Elastic 2.0.0rc1 and Kibana 4.2.0

#Installation

If necessary create your docker machine using the script
```bash
./create_docker_machine.sh <cpuCount> <memory in mb> <disk size in mb> <name of machine>
```
To build the docker instance run 
```bash
docker build -t <name for image> .
```

#Running Container From Mac
Use the shell script to run the docker instance so that ports are properly mapped
```bash
./start_container_mac.sh <docker-machine env name> <image name>
```
