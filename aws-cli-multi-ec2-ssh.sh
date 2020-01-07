#!/bin/bash

EC2_NAME=$1

echo "ec2 name: ${EC2_NAME}"

OUTPUT=`aws ec2 describe-instances --filters "Name=tag:Name,Values=${EC2_NAME}" --query 'Reservations[*].Instances[*].{instance:InstanceId,subnet:SubnetId,hostname:PublicDnsName,status:Monitoring.State,info:Tags}'`

echo "data found: ${OUTPUT}"

HOSTS=`echo ${OUTPUT} | jq -c '.[][].hostname' | sed 's/"//g'`

echo $HOSTS

read -r -p "Enter [y/n] to ssh into all the nodes listed " input

if [ $input == "y" ];
then
    xpanes -t -c "ssh -t {} 'sudo su'" ${HOSTS}
else
    echo "Not sshing into nodes"
fi

exit 1
