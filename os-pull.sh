#!/bin/bash

#############################################################################
#                                                                           #
#   Gio's minimal rice -> AWS User Data Script                              #
#   >> l alias, screenfetch, .ssh rc, .vimrc, epel repo                     #
#   >> bash.rc edit, vim, tmux, htop, pip, installed                        #  
#   >> scripts determines Linux OS then acts (AmznL2, RHEL, Ubuntu)         #  
#                                           gio@                            # 
#                                                               2022-03-01  #
#############################################################################


set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

OS="$(cat /etc/os-release | head -n 1 | cut -d '"' -f 2)"


if [[ $OS = "Amazon Linux" ]] 

then 

echo "Amazon Linux!!"
echo "alias l='ls -la'" >> /home/ec2-user/.bashrc
echo "alias myip='curl http://169.254.169.254/latest/meta-data/public-ipv4'" >> /home/ec2-user/.bashrc
echo "alias mydiid='curl http://169.254.169.254/latest/meta-data/instance-id'" >> /home/ec2-user/.bashrc
echo 'export PS1="\[\033[35m\]\t\[\033[m\]-\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "' >> /home/ec2-user/.bashrc
wget -O /home/ec2-user/screenfetch-dev https://git.io/vaHfR
chown -R ec2-user:ec2-user /home/ec2-user/screenfetch-dev
chmod +x /home/ec2-user/screenfetch-dev
mkdir /home/ec2-user/.vim
touch /home/ec2-user/.vim/vimrc
echo "set number         
syntax enable     
set tabstop=4         
set softtabstop=4    
set expandtab       
set showcmd        
set cursorline    
set wildmenu    
set showmatch" >> /home/ec2-user/.vim/vimrc
chown -R ec2-user:ec2-user /home/ec2-user/.vim
touch /home/ec2-user/install.sh 
echo "#!/bin/bash 
yum update -y 
yum install vim tmux htop python-pip figlet -y 
echo '$(hostname)'" >> /home/ec2-user/install.sh
chown ec2-user:ec2-user /home/ec2-user/install.sh
chmod 775 /home/ec2-user/install.sh 
touch /home/ec2-user/.ssh/rc
echo "#!/bin/bash
echo $(date)
bash /home/ec2-user/screenfetch-dev" >> /home/ec2-user/.ssh/rc
chown -R ec2-user:ec2-user /home/ec2-user/.ssh/rc


else
     echo "Nah, not Amazon Linux ._."

fi


if [[ $OS = "Red Hat Enterprise Linux Server" ]] 

then 
echo "Red Hat Enterprise Linux Server!!"

# set -o xtrace

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1


echo "alias l='ls -la'" >> /home/ec2-user/.bashrc
echo 'export PS1="\[\033[35m\]\t\[\033[m\]-\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "' >> /home/ec2-user/.bashrc
echo "alias myip='curl http://169.254.169.254/latest/meta-data/public-ipv4'" >> /home/ec2-user/.bashrc
echo "alias mydiid='curl http://169.254.169.254/latest/meta-data/instance-id'" >> /home/ec2-user/.bashrc
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y

mkdir /home/ec2-user/.vim
touch /home/ec2-user/.vim/vimrc
echo "set number         
syntax enable     
set tabstop=4         
set softtabstop=4    
set expandtab       
set showcmd        
set cursorline    
set wildmenu    
set showmatch" >> /home/ec2-user/.vim/vimrc
chown -R ec2-user:ec2-user /home/ec2-user/.vim
touch /home/ec2-user/install.sh 
echo "#!/bin/bash 
yum update -y 
yum install wget vim tmux htop python-pip figlet pciutils -y 
wget -O /home/ec2-user/screenfetch-dev https://git.io/vaHfR
chown -R ec2-user:ec2-user /home/ec2-user/screenfetch-dev
chmod +x /home/ec2-user/screenfetch-dev
bash /home/ec2-user/screenfetch-dev
echo '$(hostname)'" >> /home/ec2-user/install.sh
chown ec2-user:ec2-user /home/ec2-user/install.sh
chmod 775 /home/ec2-user/install.sh 
touch /home/ec2-user/.ssh/rc
echo "#!/bin/bash
echo $(date)
bash /home/ec2-user/screenfetch-dev" >> /home/ec2-user/.ssh/rc
chown -R ec2-user:ec2-user /home/ec2-user/.ssh/rc


else
     echo "Nah, not Red Hat Enterprise Server ._."

fi




if [[ $OS = "Ubuntu" ]] 

then 

echo "Ubuntu!!"
echo "alias l='ls -la'" >> /home/ubuntu/.bashrc
echo 'export PS1="\[\033[35m\]\t\[\033[m\]-\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "' >> /home/ubuntu/.bashrc
echo "alias myip='curl http://169.254.169.254/latest/meta-data/public-ipv4'" >> /home/ubuntu/.bashrc
echo "alias mydiid='curl http://169.254.169.254/latest/meta-data/instance-id'" >> /home/ubuntu/.bashrc
wget -O /home/ubuntu/screenfetch-dev https://git.io/vaHfR
chown -R ubuntu:ubuntu /home/ubuntu/screenfetch-dev
chmod +x /home/ubuntu/screenfetch-dev
mkdir /home/ubuntu/.vim
touch /home/ubuntu/.vim/vimrc
echo "set number         
syntax enable     
set tabstop=4         
set softtabstop=4    
set expandtab       
set showcmd        
set cursorline    
set wildmenu    
set showmatch" >> /home/ubuntu/.vim/vimrc
chown -R ubuntu:ubuntu /home/ubuntu/.vim
touch /home/ubuntu/install.sh 
echo "#!/bin/bash 
apt update 
apt upgrade -y 
apt install vim tmux htop python-pip figlet -y   
echo '$(hostname)'" >> /home/ubuntu/install.sh
chown ubuntu:ubuntu /home/ubuntu/install.sh
chmod 775 /home/ubuntu/install.sh 
touch /home/ubuntu/.ssh/rc
echo "#!/bin/bash
echo $(date)
bash /home/ubuntu/screenfetch-dev" >> /home/ubuntu/.ssh/rc
chown -R ubuntu:ubuntu /home/ubuntu/.ssh/rc
#mkdir /efs


else
     echo "Nah, not Ubuntu ._."

fi


#
#    ("`-/")_.-'"``-._
#      . . `; -._    )-;-,_`)
#     (v_,)'  _  )`-.\  ``-'
#    _.- _..-_/ / ((.'
#  ((,.-'   ((,/    
#
##########################


