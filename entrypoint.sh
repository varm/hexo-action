#!/bin/sh

set -e

# setup ssh-private-key
mkdir -p /root/.ssh/
echo "$INPUT_DEPLOY_KEY" > /root/.ssh/id_rsa

chmod 600 /root/.ssh/id_rsa

ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts
ssh-keyscan -t rsa e.coding.net >> /root/.ssh/known_hosts

# you can change here to router domain with defferent key with you need
cat << EOF > /root/.ssh/config
Host github.com  
    HostName github.com  
    PreferredAuthentications publickey  
    IdentityFile /root/.ssh/id_rsa

Host $GITHUB_ACTOR.github.com  
    HostName github.com  
    PreferredAuthentications publickey  
    IdentityFile /root/.ssh/id_rsa

Host e.coding.net  
    HostName e.coding.net  
    PreferredAuthentications publickey  
    IdentityFile /root/.ssh/id_rsa 

Host $GITHUB_ACTOR.coding.net  
    HostName e.coding.net  
    PreferredAuthentications publickey  
    IdentityFile /root/.ssh/id_rsa 
EOF

chmod 600 /root/.ssh/config

# setup deploy git account
git config --global user.name "$INPUT_USER_NAME"
git config --global user.email "$INPUT_USER_EMAIL"

# install hexo env
npm install hexo-cli -g
npm install hexo-deployer-git --save
npm install gulp-cli -g

git clone https://github.com/$GITHUB_ACTOR/$GITHUB_ACTOR.github.io.git .deploy_git
echo 'have clone .deploy_git'

# npm remove node-sass hexo-renderer-scss
# npm install hexo-renderer-scss

# deployment
hexo clean
if [ "$INPUT_COMMIT_MSG" == "" ]
then
    hexo clean
    hexo generate
    hexo generate
    if [ -n "$INPUT_GULP" ] &&  [ "$INPUT_GULP" = "true" ]
    then
      gulp
    fi
    hexo deploy
else
    hexo clean
    hexo generate
    hexo generate
    if [ -n "$INPUT_GULP" ] &&  [ "$INPUT_GULP" = "true" ]
    then
      gulp
    fi
    hexo deploy -m "$INPUT_COMMIT_MSG"
fi

echo ::set-output name=notify::"Deploy complate."
