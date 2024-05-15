# TODO

deploy.sh script docker commands may need sudo removed if remote server is properly configured to run docker commands without sudo.  To test: try

https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user

```
docker ps
```

# How the container was built

Retrieve PostgreSQL image from Docker Image Repository
```
docker pull postgres
```

Build and run
```
docker run --name postgres_container -e POSTGRES_PASSWORD=password -d -p 5432:5432 postgres
```

NOTE: Password is set to: password

Locating the container
```
docker ps
```

Commit Container Changes
```
docker commit <container_id> <image_name>:<tag>
```

Save Container Image
```
docker save -o <output_file.tar> <image_name>:<tag>
```


# Deploying to Server

Once the tar file of the image is transferred:
```
docker load -i my_new_image.tar
```

```
docker run -d <image_name>
```
or
```
docker run -d <image_id
```

# Helpful commands

Change name/tag of an image:
```
docker tag <image_id> <new_image_name:new_image_tag>
```

Inspect image metadata:
```
docker inspect <image_name>
```

# Using the script

Don't forget to chmod to allow execution on the bash script file
```
chmod +x deploy.sh
```
