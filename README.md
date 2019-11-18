entity-service-lambda
=========

function wrapper and related deployment for entity-service component

![overview][overview]

## Usage

### required environment variables
    
    - TF_VAR_region - aws region ( not mandatory, default: eu-west-1 )
    - TF_VAR_accountid - aws user account id ( mandatory )
    - AWS_ACCESS_KEY_ID ( mandatory )
    - AWS_SECRET_ACCESS_KEY ( mandatory )

### procedure
* clone the project;
* use `devops/tf-state.sh` to create the remote terraform state managing artifacts;
* use `devops/deploy.sh` to deploy the `entity-service` api:
  * check the output for the _api_ _url_, as for example: `url = https://e6ga9rlfva.execute-api.eu-west-1.amazonaws.com/dev` 
  * alternatively, run `cd devops/deployments/dev/ &&  terraform output url`
* now as an example, provided that you have created a table named `app1-dev-products` for one of your apps, you can now query the _api_ directly:
  * `wget https://e6ga9rlfva.execute-api.eu-west-1.amazonaws.com/dev/entities/app1/products`
  * `wget https://e6ga9rlfva.execute-api.eu-west-1.amazonaws.com/dev/entities/app1/products/{id}`

[overview]: assets/overview.png "overview"