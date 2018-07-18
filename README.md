# rpi-jenkins
Docker image for running Apache Archiva on a Raspberry Pi.

# How to Run
```shell
docker run \
  --name archiva \
  -p 8080:8080 \
  -v archiva:/var/archiva \
  --restart=always \
  --detach \
  rdeinum/rpi-apache-archiva  
```

# Links
Docker Hub: https://hub.docker.com/r/rdeinum/rpi-apache-archiva

Source: https://bitbucket.org/rdeinum/d4r-rpi-apache-archiva
