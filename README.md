# bulk-scan-shared-infrastructure

This module sets up the shared infrastructure for Bulk Scanning.Also provides ability to run CCD locally in docker containers.

## Variables

### Configuration

The following parameters are required by this module

- `env` The environment of the deployment, such as "prod" or "sandbox".
- `tenant_id` The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault.
- `jenkins_AAD_objectId` The Azure AD object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault.

The following parameters are optional

- `product` The (short) name of the product. Default is "bulk-scan". 
- `location` The location of the Azure data center. Default is "UK South".
- `appinsights_location` Location for Application Insights. Default is "West Europe".
- `application_type` Type of Application Insights (Web/Other). Default is "Web".

### Output

- `appInsightsInstrumentationKey` The instrumentation key for the application insights instance.
- `vaultName` The name of the key vault.

### Testing

Changes to this project will be run against the preview environment if a PR is open and the PR is prefixed with [PREVIEW]

### CCD Docker Setup
#### Prerequisites

* [Docker](https://www.docker.com/)

#### Steps to start ccd management web
Execute below script to start ccd locally.

  ```bash
  $ ./bin/start-ccd-web.sh
  ```

This will:
- start ccd and and dependent services locally
- mount database volumes, to which your data will persist between restarts,
- expose container ports to the host, so all the APIs and databases will be directly accessible. Use `docker ps` or read the [compose file](./docker-compose.yml) to see how the ports are mapped.

To stop the environment use the same script, just make sure to pass the `local` parameter:

```bash
$ ./bin/stop-environment.sh
```
  
Once the containers are up, we can then create caseworker user to login into CCD. 

By default `caseworker-sscs` role is assigned to the user.
If you want to change the role pass in appropriate role while executing the script. User role should exists in Idam.

  ```bash
   $ ./bin/create-case-worker.sh
  ```

####  CCD definition

In order to upload new definition file, put the definition file at location 
'docker/ccd-definition-import/data/CCD_Definition_BULK_SCAN.template.xlsx'

Make sure caseworker created in above step is configured in the UserProfile tab of the definition file and has correct roles.

#### Uploading CCD definition

```bash
$ ./bin/upload-ccd-spreadsheet.sh
```

#### Debugging
If an error occurs try running the script with a `-v` flag after the script name

```bash
$ ./bin/upload-ccd-spreadsheet.sh -v
```
#### Login into CCD
Open management web page http://localhost:3451 and login with user created above

#### Some nice things to know
* Allocate enough memory to docker to spin up all the containers. 4 GB would be recommended.

* You can pass flags while creating docker container for e.g to recreate all containers from scratch.

  ```bash
  $ ./bin/start-ccd-web.sh --force-recreate
  ```
  
* You can delete all containers by executing below command.

 ```bash
  $ docker rm $(docker ps -a -q)
  ```
  
* You can remove all images by executing below command.

 ```bash
  $ docker rmi $(docker images -q)
  ```
  
* To list all volumes created run below command.

```
  $ docker volume ls
  ```
  
* In case you want to remove docker volumes to destroy database volume mount run below command.

 ```
  $ docker volume rm <volume name>
  ```
 
