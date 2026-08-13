#!/bin/bash
########################
# Author: Aryan Arora
# Date: 17 July 2026
# version: v1
# This script will report the AWS resource usage
########################

#set -x # debug mode
set -e

# List buckets in S3
echo "Print S3 buckets"
aws s3 ls > resourceTracker # overwrite the output in resourceTracker file

# List EC2 instances
echo "Print list of EC2 instances"
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId' >> resourceTracker # append the output in resourceTracker

# print list of lambda functions
echo "Print list of lambda functions"
aws lambda list-functions | jq '.Functions[].FunctionArn' >> resourceTracker

# print list of iam users
echo "print list of IAM users"
aws iam list-users | jq '.Users[].Arn' >> resourceTracker
