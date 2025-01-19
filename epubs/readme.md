https://github.com/bcliang/docker-libgourou

# adobe credentials live in ~/bin/adobe_cred

docker run \
    -v ~/bin/adobe_creds:/home/libgourou/.adept \
    -v $(pwd):/home/libgourou/files \   # your source and target epub will and need to live here.
    --rm bcliang/docker-libgourou \
    URLLink\(1\).acsm 


# interactive terminal.
docker run \
    -v {$PATH_TO_ADOBE_CREDS}:/home/libgourou/.adept \
    -v $(pwd):/home/libgourou/files \
    -it --entrypoint /bin/bash \
    bcliang/docker-libgourou
