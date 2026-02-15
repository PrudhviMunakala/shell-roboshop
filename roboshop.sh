#!/bin/bash

SG_ID="sg-02ea97487c317f700"
AMI_ID="ami-0220d79f3f480ecf5"


aws ec2 run-instances --image-id ami-0220d79f3f480ecf5 --security-group-ids sg-02ea97487c317f700 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=catalogue}]" --instance-type t3.micro


