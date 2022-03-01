#ec2-launch

Launch a T3.micro EC2 instance, log its ID & publicDNS name, execute a user data script (os-pull.sh) & SSH in

### Usage
`./start-ec2.sh -k '<key-name>' -sg '<security-group>'`

- where <key-name> is your .pem keypair's name without the extension '.pem'
- where <security-group> format example: 'sg-XXXXXX'

### Dependencies
- jq
- figlet
- aws cli 
- an AWS-configured SSH keypair 
- a security group that allows your IP address SSH access

### After SSH access
Run `install.sh` for updates if desired:

`ec2-user@ip-172-31-88-176:~$ sudo ./install.sh `