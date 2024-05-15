#!/bin/bash

echo "Moving files to server"

# Image file path
local_file="postgres.tar"

# Remote server details
remote_user="jtan"
remote_host="192.168.1.206"
remote_directory="/home/jtan/service-demo"

# Image name
image_name=""

# Check if the local file exists
if [ ! -f "$local_file" ]; then
    echo "Error: Local file $local_file not found."
    exit 1
fi


# Load Docker Image on remote server
load() {
    echo "Loading docker image"
    ssh_command="sudo docker load -i $remote_directory/$local_file"
    ssh_output=$(ssh "$remote_user"@"$remote_host" "$ssh_command")
    echo $ssh_output

    if [[ $ssh_output =~ .*"Loaded image: "([^[:space:]]+).* ]]; then
        loaded_image="${BASH_REMATCH[1]}"
        # echo "Substring after 'Loaded image:': $loaded_image"
    else
        echo "Substring 'Loaded image:' not found in input string."
    fi

    image_name=$loaded_image
}

# Run Docker Image on remote server
run() {
    echo "Running docker image"
    ssh_command="sudo docker run -d $image_name"
    ssh_output=$(ssh "$remote_user"@"$remote_host" "$ssh_command")
    echo $ssh_output
}

# Copy the file to the remote server using scp
scp "$local_file" "$remote_user"@"$remote_host":"$remote_directory"

# Check if scp command was successful
if [ $? -eq 0 ]; then
    echo "File copied successfully to remote server."
    load
    if [ $? -eq 0 ]; then
        run
        if [ $? -eq 0 ]; then
            echo "Success."
        else
            echo "Error: Failed to run image on docker on remote server".
        fi
    else
        echo "Error: Failed to load image to docker on remote server".
    fi
else
    echo "Error: Failed to copy file to remote server."
fi
