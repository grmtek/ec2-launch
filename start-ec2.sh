#!/bin/bash

#########################################################################
#                                                                       # 
# Launch a T3.medium EC2 instance; pull its ID & publicDNS name & SSH in#
#          with a user data script                                      # 
#                                        gio@                           #
#                                                         2019-05-24    #    
#########################################################################

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

amazonlinuxami="$(aws ec2 describe-images --owners amazon --filters 'Name=name,Values=amzn2-ami-hvm-2.0.????????-x86_64-gp2' 'Name=state,Values=available' --output json | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId')" 
                                                                    ## this will pull the latest Amazon Linux 2 AMI
instancetype=t2.micro
keyname=example_key #your key name goes here -- pass string w/o .pem / leave out .pem
securitygroup=sg-xxxx ## your security group name goes here
userdata=file:///os-pull.sh
instanceprofile="gmoney-madness" ## your instance profile name goes here, or remove reference to IAM-instance profile on line 45


###########################################################

echo "Amazon Linux ami:" $amazonlinuxami
echo "Instance Type:" $instancetype "Key Name:" $keyname
echo "Security Group:" $securitygroup
echo "User Data script:" $userdata

sleep .5

echo "Commencing Launch in 3..."
sleep 1 
echo "2..." 
sleep 1
echo "1..."
sleep 1

###########################################################

aws ec2 run-instances --image-id $amazonlinuxami --count 1 --instance-type $instancetype \
--key-name $keyname --security-group-ids $securitygroup \
 --iam-instance-profile Name="$instanceprofile" --user-data $userdata | tee $HOME/logs/log-ec2  ## logs and processes stdout to $HOME/logs  
sleep 3.5
echo "INSTANCE ID:"
cat $HOME/logs/log-ec2 | grep -i "instanceid" | cut -d'"' -f4 

###########################################################

instance="$(cat $HOME/logs/log-ec2 | grep -i "instanceid" | cut -d'"' -f4)"
echo "PUBLIC DNS:"
echo $(aws ec2 describe-instances --instance-id $instance | grep -i PublicDnsName | cut -d'"' -f4 | uniq)
publicdns="$(aws ec2 describe-instances --instance-id $instance | grep -i PublicDnsName | cut -d'"' -f4 | uniq)"

echo $(date) 'instance:' $instance 'publicDNS:' $publicdns >> $HOME/logs/instance-log

##########################################################

echo "Waiting for instance to change to 'Running'"

aws ec2 wait instance-running --instance-ids "$instance"
figlet "Running"

echo "Instance running. Waiting 10 seconds for user data injection to complete"
sleep 7
echo "3..."
sleep 1
echo "2..."
sleep 1
echo "1..."

ssh -i ~/.ssh/$keyname.pem ec2-user@$publicdns
 


#
#    ("`-/")_.-'"``-._
#      . . `; -._    )-;-,_`)
#     (v_,)'  _  )`-.\  ``-'
#    _.- _..-_/ / ((.'
#  ((,.-'   ((,/    
#
##########################

