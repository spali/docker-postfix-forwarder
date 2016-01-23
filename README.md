# docker-postfix-forwarder

Simple postfix forwarder which forward accept all mail from a network and replay them to a defined host with auth support.

## Usage

#####build the image
```
git clone https://github.com/spali/docker-postfix-forwarder.git
docker build -t postfix-forwarder docker-postfix-forwarder
```

#####create the container:
```
docker create --name postfix-forwarder \
        --restart always \
        --publish 25:25 \
        --env CONF_POSTFIX_RELAYHOST=[relayhost]:port \
        --env CONF_POSTFIX_RELAY_USER=mymail@domain.org \
        --env CONF_POSTFIX_RELAY_PASSWORD=mysecretpassword \
        --env CONF_POSTFIX_MYNETWORKS=192.168.0.0/24 \
        postfix-forwarder
```

