#!/bin/bash

SG_ID="sg-02ea97487c317f700"
AMI_ID="ami-0220d79f3f480ecf5"


for instance in $@
do
    instance_id=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --instance-type t3.micro \
    --query 'Instances[0].PrivateIpAddress' \
    --output text
    )

    if [ $instance_id == "frontend" ]; 
    then
       IP=$(
        aws ec2 describe-instances \
        --instance-ids $instance_id \
        --query 'Reservations[].Instances[].PublicIpAddress' \
        --output text
        ) 
    else 

    IP=$(
        aws ec2 describe-instances \
        --instance-ids $instance_id \
        --query 'Reservations[].Instances[].PrivateIpAddress' \
        --output text
        )
    fi

done



