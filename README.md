# cubrid-cmd
cubrid helper commands for Linux bash; works also on Windows via gitBash or Linux subsystem

1. choose a base folder
  mkdir ~/cubrid
  cd ~/cubrid
2. clone this repo in the previously selected folder
  git clone https://github.com/bsolomenco/cubrid-cmd
3. make command(s) avalable
  chmode +x ~/cubrid/cubrid-cmd/cubridcmd.sh
  3.1 add to PATH
    PATH += ~/cubrid/cubrid-cmd
  3.2 make aliase(s) in ~/.bashrc
    alias cubridcmd='~/cubrid/cubrid-cmd/cubridcmd.sh'
