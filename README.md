## Part 1: Terraform + VPC + ECS

This project involves setting up the following AWS resources:

1. **VPC**
2. **Subnets**
   - 2 Private subnets
   - 2 Public subnets
   - Route tables for subnets
3. **Internet Gateway**
4. **Security Groups**
   - For Application Load Balancer (ALB)
   - For ECS
5. **Application Load Balancer**
   - Internet-facing (public subnets)
6. **ECR (Elastic Container Registry)**
   - Manually create the ECR repository and import the existing resource.
   - Build a "Hello World" Docker image from a Dockerfile and push it to ECR.
   - Private ECR (internal access)
   - Encrypted ECR
   - Private endpoints (created by Terraform)
7. **ECS (Elastic Container Service)**
   - Task definition with a container in private subnets
   - Service with 2 desired containers

### Notes
- Resources should be highly available (2 Availability Zones).
- The Application Load Balancer is the only resource accessible from the Internet.

## Part 2: CI/CD Pipeline

Create an end-to-end CI/CD pipeline with Amazon ECR and AWS CodePipeline.

### CodeBuild
1. Create the CodeBuild service role.
2. Create Build projects and a `buildspec.yaml` that includes:
   - Docker build and tag with short commit ID.
   - Docker push to ECR.
   - Create a new ECS task definition with the new image.
   - Update ECS service to use the new task definition.

### CodePipeline
1. Create a new pipeline.
2. Configure the branch to trigger the pipeline.
3. Run CodeBuild with the Build projects.
