#!/bin/bash

########################################################
# env-specific dirs = as env variables
########################################################
export ENV_HOME=~/dev
export APPS_HOME=$ENV_HOME/apps
export WORKSPACE_HOME=$ENV_HOME/ws
export DEPLOY_HOME=$ENV_HOME/deploy
export LOGS_HOME=$ENV_HOME/logs


########################################################
# creating environment directories if they do not exist
# setting aliases to quickly access them
########################################################
for DIRECTORY in $DEV_HOME $APPS_HOME $WORKSPACE $ENV_HOME $LOGS_HOME
do
    if [ ! -d "$DIRECTORY" ]; then
        echo "creating directory: $DIRECTORY"
        mkdir $DIRECTORY
    fi
done

alias cde="cd $ENV_HOME"
alias cda="cd $APPS_HOME"
alias cdw="cd $WORKSPACE_HOME"
alias cdd="cd $DEPLOY_HOME"
alias cdl="cd $LOGS_HOME"

#################################################
# setting environment variables for applications
#################################################
if [ -n "${JAVA_HOME:-x}" ]; then
    export JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk
fi
export GRADLE_HOME=$APPS_HOME/gradle
export ERLANG_HOME=$APPS_HOME/erlang

echo ""
echo "***ENV VARIABLES***"
env | grep HOME

export PATH=$JAVA_HOME/bin:$GRADLE_HOME/bin:$ERLANG_HOME/bin:$PATH

#################################################
# installing applications if they do not exist
#################################################
if [ ! -L "$APPS_HOME/gradle" ]; then
    echo "***Installing Gradle***"
    wget --directory-prefix=$APPS_HOME http://services.gradle.org/distributions/gradle-1.2-bin.zip
    unzip $APPS_HOME/gradle-1.2-bin.zip -d $APPS_HOME
    ln -s $APPS_HOME/gradle-1.2 $APPS_HOME/gradle
    rm gradle-1.2-bin.zip
fi

if [ ! -d "$APPS_HOME/jenkins" ]; then
    echo "***Installing Jenkins CI***"
    mkdir $APPS_HOME/jenkins
    wget --directory-prefix=$APPS_HOME/jenkins http://mirrors.jenkins-ci.org/war/latest/jenkins.war
fi
echo "$JAVA_HOME/bin/java -jar $APPS_HOME/jenkins/jenkins.war --ajp13Port=-1 --httpPort=31114 --logfile=$LOGS_HOME/jenkins.log" > $APPS_HOME/jenkins/start_jenkins
chmod 744 $APPS_HOME/jenkins/start_jenkins
alias jenkins_start="nohup $APPS_HOME/jenkins/start_jenkins &"
alias jenkins_monitor="ps -auxxx | grep jenkins"
alias jenkins_weblog="less /home/damienlee/logs/frontend/access_jenkins.log"

if [ ! -L "$APPS_HOME/erlang" ]; then
    echo "***Installing Erlang/OTP***"
    mkdir $APPS_HOME/erlang
    wget --directory-prefix=$APPS_HOME http://www.erlang.org/download/otp_src_R15B02.tar.gz
    tar -xzvf $APPS_HOME/otp_src_R15B02.tar.gz -C $APPS_HOME
    rm $APPS_HOME/otp_src_R15B02.tar.gz
    ln -s $APPS_HOME/otp_src_R15B02 $APPS_HOME/erlang
    echo "***ERLANG DOWNLOADED BUT NOT COMPILED - PLEASE FINISH THIS ACTION IN $APPS_HOME/erlang DIRECTORY***"
fi

echo "***************************************************"
echo "** Environment $ENV_HOME setup complete"
echo "***************************************************"
