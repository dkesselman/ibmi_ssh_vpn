#!/usr/bin/bash

#CONSTANTS & VARIABLES
QIBM_MULTI_THREADED='Y'
export QIBM_MULTI_THREADED

GROUP="GRPFREE"
USRCLS="*PGMR"
SPCAUT="*JOBCTL"
DOTFILES="/dotfiles/.bash*"
WINTOOLS="/WINTOOLS/*"
HOST="myremote-server-ip"
TELNETPORT="8023"
REMOTEPORT="443"
HOMEPATH="$CHROOTPATH./home/$1"

# This is for IBMi V7R1
CHROOTCMD="/QOpenSys/QIBM/ProdData/SC1/OpenSSH/openssh-4.7p1/sbin/chroot_setup_script.sh"
CHROOTPATH="/QOpenSys/QIBM/UserData/SC1/OpenSSH/openssh-4.7p1/chroot/"
###############################################################
# This is for IBMi V7R2
#CHROOTCMD="/QOpenSys/QIBM/ProdData/SC1/OpenSSH/sbin/chroot_setup_script.sh"
#CHROOTPATH="/QOpenSys/QIBM/UserData/SC1/OpenSSH/chroot/"

echo '----------------------------------------------------------------------------------------------'
echo 'Begining'
echo '----------------------------------------------------------------------------------------------'

CRTUSRCMD="CRTUSRPRF USRPRF($1) PASSWORD($2) USRCLS($USRCLS) CURLIB($1) TEXT('$3') SPCAUT($SPCAUT) GRPPRF($GROUP) HOMEDIR('$HOMEPATH')"

echo "CRTUSRCMD: $CRTUSRCMD" 

# Create Library
system  $CRTUSRCMD
system  "CRTLIB $1"
system  "CHGAUT OBJ('/QSYS.LIB/$1.LIB') USER($1) DTAAUT(*RWX) OBJAUT(*ALL)"
system  "CHGAUT OBJ('/QSYS.LIB/$1.LIB') USER(*PUBLIC) DTAAUT(*EXCLUDE) OBJAUT(*NONE)"

# Create IFS chrooted home directory
mkdir -p $HOMEPATH/.ssh
mkdir -p $HOMEPATH/IBMi
cp /dotfiles/.bash* $HOMEPATH/
cp $WINTOOLS $HOMEPATH/IBMi/
chmod -R 700 $HOMEPATH
chown -R $1 $HOMEPATH

#Create Public/Private Keys
ssh-keygen -N "" -f $HOMEPATH/.ssh/$1.pvk
mv $HOMEPATH/.ssh/$1.pvk.pub $HOMEPATH/.ssh/authorized_keys
mv $HOMEPATH/.ssh/$1.pvk $HOMEPATH/IBMi/
chmod -R 600 $HOMEPATH/.ssh

#Creating script

echo "@echo off" > $HOMEPATH/IBMi/$1.cmd 
echo "Title $HOST Remote Access (3128)" >> $HOMEPATH/IBMi/$1.cmd
echo ":loop1" >> $HOMEPATH/IBMi/$1.cmd
echo "c:\IBMi\plink -v -C $1@$HOST -P $REMOTEPORT -pw $2 -D 3128 -L $TELNETPORT:127.0.0.1:23 -L 449:127.0.0.1:449 -L 8470:127.0.0.1:8470 -L 8471:127.0.0.1:8471 -L 8472:127.0.0.1:8472 -L 8473:127.0.0.1:8473 -L 8474:127.0.0.1:8474 -L 8475:127.0.0.1:8475 -L 8476:127.0.0.1:847n" >> $HOMEPATH/IBMi/$1.cmd
echo  "goto loop1" >> $HOMEPATH/IBMi/$1.cmd

#Creating ZIP 
cd $HOMEPATH/IBMi
jar -cvfM $1.zip *

echo 'THE END!'

