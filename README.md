# datascience-r

Docker files for data science with R

This repo contains a Dockerfile for building a container with RStudio and some often-used packages. The container is based on the rocker/verse Docker container. The build procedure below assumes a docker client is installed locally. The GCP piece assumes there is a GCP project set up (e.g. pmcrosta-datascience).

# Building the image

Clone the repo and run the following in the directory to build the container:

`docker build -t datascience-r .`

# Adding to Google Container Registry

* Enable the Container Registry API in GCP
* Ensure GCP SDK is installed from https://cloud.google.com/sdk/docs/
* Follow steps at https://cloud.google.com/container-registry/docs/quickstart
 * `$ gcloud auth configure-docker`
 * `$ docker tag datascience-r gcr.io/pmcrosta-datascience/datascience-r:latest` where pmcrosta-datascience is the GCP project name
 * `$ docker push gcr.io/pmcrosta-datascience/datascience-r:latest`


# Launching GCE instance with container

* Set environment variable to control machine size and desired rstudio password
 * `$ MACHINETYPE=g1-small`
 * `$ PASSWORD=change_this`
* Use gcloud SDK to launch instance (can also be done through GUI)
 * `$ gcloud beta compute --project=pmcrosta-datascience instances create-with-container dsserver --zone=us-east1-c --machine-type=$MACHINETYPE --subnet=default --maintenance-policy=MIGRATE --service-account=943134138766-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --min-cpu-platform=Automatic --tags=rstudio,http-server --image=cos-stable-65-10323-69-0 --image-project=cos-cloud --boot-disk-size=100GB --boot-disk-type=pd-ssd --boot-disk-device-name=dsserver --container-image=gcr.io/pmcrosta-datascience/datascience-r:latest --container-restart-policy=always --container-privileged --container-env=ROOT=TRUE,PASSWORD=$PASSWORD`
 * Currently this command requires "gcloud beta compute..."
* Also create firewall rule to allow access to 8787
 * `$ gcloud compute --project=pmcrosta-datascience firewall-rules create rstudio --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:8787 --source-ranges=0.0.0.0/0 --target-tags=rstudio`
 `$ gcloud compute --project=pmcrosta-datascience firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server`
* Access RStudio via the http://external_ip:8787
* To shut down instance
 * `$ gcloud compute instances stop dsserver`
* To delete instance
 * `$ gcloud compute instances delete dsserver`

# TODO

Thus far we have created a custom/extended/modified Docker image, uploaded it to GCP Container Registry, and launched a VM on GCE running the container. This is enough to get things going and to run some code. However, there are other items that are common in the analysis workflow, such as:
* Streamlining Git setup to quickly clone repository code and integrate into R project
* Mounting GCS storage over Fuse to facilitate access to persistent storage
* Incorporating shiny server to also run on the VM
* Adding nginx and suitable proxies (helps with prettier URLs, avoiding explicit ports in URLs)
* Investigate GCP Container Builder to automate build process when Github Dockerfile is modified


# Helpful commands

To build a container:

`$ docker build -t datascience-r .`

To for a rebuild:

`$ docker build --no-cache -t datascience-r .`

To list images:

`$ docker image ls -a`

To run the container:

`$ docker run -d -e ROOT=TRUE -p 8787:8787 datascience-r`

To list containers:

`$ docker container ls -a`

To ssh into a container with ID `container_id`

`$ docker exec -it container_id /bin/bash`

To ssh into a version of the container as root:

`$ docker run --rm -ti datascience-r  bash`

To stop the container with ID `container_id`

`$ docker container stop container_id`

To remove all stopped containers

`$ docker container prune`

To get a list of installed debian packages

`$ dpkg -l | less`
