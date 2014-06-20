This is a container that uses Nginx as a Load Balancer for a Node.js application using Serf for auto-discovery of new nodejs containers.

It does not depend on Node.js but the serf-member-join.sh script will detect any node.js (or web) container available to Serf and add it to the load balancer.

Nginx will not check if a host is alive, that's Serf's job.

The nginx.conf file it's configured to serve static files, but it needs access to the static files at /var/www so make sure you link the volume with your application when running the container.

I'm using fig to start the container, this is the important part:

	serf:
	  image: luis/serf
	  ports:
	   - "7373"
	   - "7946"
	web:
	  build: .
	  links:
	   - mongodb:mongodb
	   - elasticsearch:elasticsearch
	   - serf:serf
	  expose:
	   - "3000"
	  volumes:
	   - "/var/www:/var/www"
	   - "/var/log/docker:/var/log/supervisor"
	   - "/var/files:/var/files"
	  environment:
	   MONGODB_DATABASE: somedb
	   NODE_ENV: production
	lb:
	  image: luis/nginx-lb
	  ports:
	    - "80:80"
	  links:
	    - serf:serf
	  volumes:
	   - "/var/www:/var/www"
	   - "/var/log/docker:/var/log/supervisor"
	   - "/var/files:/var/files"

As you can see, both my load balancer and web application links to the serf container. I'm also mounting the same volumes for both my web container and the lb container. Finally, the web container will be built using a Dockerfile that I'm including in my application.