# AdminToolsImageGenerator

Simple Powershell module to build my day to day updated admin toolbox container image that will be hosted on a [public Github container registry](https://github.com/SCOMnewbie/AdminToolsImageGenerator/pkgs/container/admintools). Usually people create a Docker image and mainly update the "FROM" image from time to time. But what about the dependancies? This is the goal of this project! Once you execute the **./build.ps1 -task .** the automation will fetch the latest updates of all dependancies and inject them in a generated Dockerfile and then build and publish the image.

This module is using the [Sampler module](https://github.com/gaelcolas/Sampler) from Gael Colas.

## How to build locally

1. Checkout the repository
2. run ./build.ps1 -Tasks . -ResolveDependency that will:
    - Download all required modules
    - Build the module based on few functions
    - Test the module, the required file (template) and the generated Dockerfile
    - Fail on the Docker connect because a Personal Access Token must be exposed trough a PAT environment variable. If declared, the Docker image will be build from the generated Dockerfile and published.

**Note**: Few things are hardcoded just for this usecase. Of course we can improve the process.

## How to build with Github Action

1. Make sure you create a Personal Access Token must be exposed trough a PAT secret environment variable.
2. Run the CI job. Few minutes after the updated image should be publisehd.

## Which tools are included?

- Terraform
- Vault
- Copacetic
- Trivy
- Az copy
- Az CLI
- AWS CLI
- Cuelang
- Open Policy Agent (OPA)
- Kubectl with Kubelogin plugin
- Powershell modules:
    - Pester
    - Az.accounts
    - Az.resources
    - PSMSALNet
