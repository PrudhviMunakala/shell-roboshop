#!/bin/bash

SG_ID="sg-02ea97487c317f700"
AMI_ID="ami-0220d79f3f480ecf5"
ZONE_id="Z03858732HUVY50OKOZOA"
DOMAIN-NAME="ptdevops.online"


for instance in $@
do
    instance_id=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --instance-type t3.micro \
    --query 'Instances[0].InstanceId' \
    --output text
    )

    if [ $instance_id == "frontend" ]; then
    IP=$(
            aws ec2 describe-instances  \
            --instance-ids $instance_id  \
            --query 'Reservations[].Instances[].PublicIpAddress' \
            --output text
        ) 
        RECORD_NAME="$DOMAIN_NAME"
    else 
    IP=$(
            aws ec2 describe-instances  \
            --instance-ids $instance_id  \
            --query 'Reservations[].Instances[].PrivateIpAddress' \
            --output text
        )
        RECORD_NAME="$instance.$DOMAIN_NAME"
    fi
echo "Instance IP address is : $IP"

aws route53 change-resource-record-sets \
  --hosted-zone-id $ZONE_id \
  --change-batch '
  {
    "Comment": "Updatinging '$instance' record",
    "Changes": [
        {
        "Action": "UPSERT",
        "ResourceRecordSet": {
            "Name": "'$RECORD_NAME'",
            "Type": "A",
            "TTL": 1,
            "ResourceRecords": [
            {
                "Value": "'$IP'"
          }
        ]
      }
    }
  ]
    }
  
  '
  echo "record updated for $instance"
done



