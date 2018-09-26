# ibmi_ssh_vpn

With SSH on IBMi you can connect remote users to your system, but sometimes you have too much power because of PASE.

This is just a script to create users with their own CURLIB , /home/USER directory on IFS using CHROOT.

Requirements:

* IBMi V7R1 or higher
* OpenSSH
* BASH (use YUM to install)

How to install:

* On V7R1 you can just copy this script on /home/MYUSER or any other path on IFS
* On V7R2 o V7R3 you need to change some paths from OpenSSH and CHROOT
* You need to copy your favorite .bash_profile, .profile, .bashrc to /dotfiles
* You need to copy plink.exe (can download from PuTTY page) to /WINTOOLS
* You need to run chroot_setup_script.sh from PASE:
* Needs no change some variables pointing to your system
* Add at the end of your sshd_config:

ibmpaseforishell /usr/bin/bash
ibmpaseforienv PASE_USRGRP_LIMITED=N

* Need to run CHROOT Script:

  On V7R1:
  CALL QP2TERM
  /QOpenSys/QIBM/ProdData/SC1/OpenSSH/openssh-4.7p1/sbin/chroot_setup_script.sh
  
  On V7R2:
  CALL QP2TERM
  /QOpenSys/QIBM/ProdData/SC1/OpenSSH/sbin/chroot_setup_script.sh
  

 
How this works:

* Creates user profile with his own library (*PUBLIC *EXCLUDE)
* Creates chrooted home directory
* Copies some dotfiles so you can use BASH with colours, alias and cool stuff like that
* Creates a public and private key using SSH-KEYGEN command, then renames public key to authorized_keys
(Note, if you want to use public/private keys you need to convert to PuTTY format using PuTTYGEN and change plink.exe line)
* Copies plink.exe from /WINTOOLS to a temporary directory
* Creates a .CMD file with plink command so you can create a tunneled connection to the IBMi
* Creates a .ZIP file with all these files

With this .ZIP file the client just uncompress files on c:\IBMi, runs the .CMD script, and can connect using iACS, TN5250j , or any other tool they want

I also includes syslog.conf, so you can monitor access.
Just need to copy syslog.conf on /QOpenSys/etc

... and sshd_config

How to create a user:

From PASE with "CALL QP2TERM" or connected from SSH run 

./ibmi_ssh_vpn.sh USERPROFILE PASSWORD 'User Profile Description'

Now you can give the .ZIP on IBMi directory  to the remote user. 
He needs to unzip on C:\IBMi\ and run USERPROFILE.cmd  to connect to your system

And that's it.

TODO:

* I'm thinking about creating a two server version, using remote tunnel and local tunnes, connecting IBMi to a cloud server and remote user script will meet IBMi on the cloud. 

IBMi <---> Cloud Server <---> Client

* On next version I have to find a solution to certificate conversion. PLINK uses PuTTY format and IBMi creates an OpenSSH certificate.
 
