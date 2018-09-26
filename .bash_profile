export TERM=aixterm
export PS1="\u@\[\e[32m\]\H\[\e[m\]:\w>"
##export PS1="\u@\H:\w>\[$(tput sgr0)\]"
alias mc="LC_ALL=EN_US.UTF-8 /QOpenSys/pkgs/bin/mc -c"
alias db2='function _db2(){ echo "Running $1"; system -i "call QSYS/QZDFMDB2 parm('\''$1'\'')"; };_db2'
PATH=/QOpenSys/pkgs/bin:/opt/freeware/bin:$PATH
export PATH

