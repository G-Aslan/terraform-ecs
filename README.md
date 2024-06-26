Resources:
- VPC.
- 4 Subnets - 2 Private subnets, 2 Public subnets and route tables.
- Internet Gateway.
- Security Groups - for ALB and ECS.
- Application Load Balancer - Internet-facing (public subnets).
- ECR - you may create the ECR repository manually and use data to import the existing resource.
    - Build a "Hello World" docker image from a Dockerfile and push it to ECR.
    - Private ECR (internal access).
    - Encrypted ECR.
    - Private endpoints.  (created by Terraform)
- ECS -
    - Task definition with a container - private subnets.
    - Service with 2 desired containers.

Notes: 
- Resources should be highly available (2 AZs).
- Application Load Balancer is the only resource that can be accessed from the Internet.
- Use variable for all the dynamic parameters such as region, AZs, CIDR block ETC.
- You may search Google for anything you need.

**TASK 2:**

 Create an end-to-end CI/CD pipeline with Amazon ECR and AWS CodePipeline.

- CodeBuild:
    - Create the CodeBuild service role.
    - Create Build projects and buildspec.yaml that includes:
        - docker build and tag with short commit ID.
        - docker push to ECR.
        - create a new task with the new image.
        - update ECS service to use the new task.
- CodePipeline:
    - Create a new pipeline.
    - Configure the branch to trigger the pipeline.
    - Run CodeBuild with the Build projects.
