#!/usr/bin/env bash

ACCESS_KEY="AKIAT3JZ3TBLHWUHYBM5"
SECRET_KEY="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"

BUCKET_NAME_DEPLOY="bucket-log8415"
BUCKET_NAME_ARTEFACT="artifacts-log8415"

# setting aws credentials
aws configure set aws_access_key_id = $ACCESS_KEY
aws configure set aws_secret_access_key = $SECRET_KEY

# First Bucket for Source Code, Second Bucket for Artifacts generated by pipeline
aws s3api create-bucket --bucket $BUCKET_NAME_DEPLOY
aws s3api create-bucket --bucket $BUCKET_NAME_ARTEFACT --acl public-read-write
aws s3api put-bucket-policy --bucket $BUCKET_NAME_DEPLOY --policy file://policy_deploy.json
aws s3api put-bucket-policy --bucket $BUCKET_NAME_ARTEFACT --policy file://policy_artifacts.json
aws s3 website s3://$BUCKET_NAME_DEPLOY/ --index-document index.html

# policy copied from the AWS policies (S3FullAccess)
ROLE_NAME="role-pipeline-log8415"
# Creating new Role and assuming role
aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document file://role_policy_document.json
# Attaching the S3FullAccess Policy to this role
aws iam put-role-policy --role-name $ROLE_NAME --policy-name AmazonS3FullAccess --policy-document file://policy_role.json

# pipeline creation
aws codepipeline create-pipeline --cli-input-json file://pipeline.json --region us-east-1


# Get-Info
# aws codepipeline get-pipeline --name pipeline --region us-east-1
# aws sts get-caller-identity
