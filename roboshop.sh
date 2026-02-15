#!/bin/bash

SG_ID="sg-02ea97487c317f700"
AMI_ID="ami-0220d79f3f480ecf5"


for $INSTANCE in $@
do
aws ec2 run-instances \
--image-id $AMI_ID \
--security-group-ids $SG_ID \
--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE}]" \
--instance-type t3.micro \
--query 'Instances[0].PrivateIpAddress' \
--output text
done


