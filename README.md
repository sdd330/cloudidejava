# Cloud9 IDE with Java
Cloud9 IDE with Java

## Usage

To start an instance:

	docker run -d -p 80:80 -p 8080:8080 -p 8585:8585 -p 3000:3000 -v `pwd`:/workspace -v /var/run/docker.sock:/var/run/docker.sock --name cloudidejava sdd330/cloudidejava
