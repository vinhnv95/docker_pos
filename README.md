# docker_pos

## Run Services
```sh
./run.sh -f {folder to run} -- up -d
```

To run service with Elasticsearch, add option `-es` to command
```sh
./run.sh -es -f {folder to run} -- up -d
```

## Stop Service
```sh
./run.sh -f {folder to run} -- stop
```

## Stop and remove service
```sh
./run.sh -f {folder to run} -- down
```