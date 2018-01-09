# cubrid-cmd (cubrid helper commands for bash)
works also on Windows via gitBash or Linux subsystem

1. choose a base folder
```
mkdir ~/cubrid
```
2. clone this repo in the previously created folder
```
git clone https://github.com/bsolomenco/cubrid-cmd ~/cubrid
```
3. make command avalable system-wide (one of the following ways)
  * 3.1. add to PATH
```
PATH += ~/cubrid/cubrid-cmd
```
  * 3.2 make aliase(s) in ~/.bashrc (name them however you like)
```
alias cubridcmd='~/cubrid/cubrid-cmd/cubridcmd.sh'
alias clone='cubridcmd clone'
alias gen='cubridcmd gen'
alias build='cubridcmd build'
alias inst='cubridcmd inst'
alias genDb='cubridcmd genDb'
alias vg='cubridcmd vg'
```
4. use it
```
cd ~/cubrid
cubridcmd           #show available commands

clone [cub]         #clone a cubrid repo; default cub
gen                 #generate project for current platform/OS (Linux: "Unix Makefiles", Windows: "Visual Studio 2017 Win64")
build               #build generated project
inst [port]         #install and update ports
genDb [db=testdb]   #generate database (default testdb)
clone tt [prefix]   #clone testtools, testtools-internal
clone tc [prefix]   #clone testcases, testcases-private, testcases-private-ex
```
5. resulting folder structure
```
cubrid
    cubrid-cmd
    repo
    build
    inst
    db
    cubrid-testtools
    cubrid-testtools-internal
    cubrid-testcases
    cubrid-testcases-private
    cubrid-testcases-private-ex
```
