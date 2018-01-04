# cubrid-cmd (cubrid helper commands for bash)
works also on Windows via gitBash or Linux subsystem

1. choose a base folder
```
mkdir ~/cubrid
cd ~/cubrid
```
2. clone this repo in the previously selected folder
```
git clone https://github.com/bsolomenco/cubrid-cmd .
```
3. make command executable and avalable system-wide
```
chmode +x ~/cubrid/cubrid-cmd/cubridcmd.sh
```
  3.1 add to PATH
```
PATH += ~/cubrid/cubrid-cmd
```
  3.2 make aliase(s) in ~/.bashrc
```
alias cubridcmd='~/cubrid/cubrid-cmd/cubridcmd.sh'
alias clone='~/cubrid/cubrid-cmd/cubridcmd.sh clone'
alias gen='~/cubrid/cubrid-cmd/cubridcmd.sh gen'
alias build='~/cubrid/cubrid-cmd/cubridcmd.sh build'
alias inst='~/cubrid/cubrid-cmd/cubridcmd.sh inst'
```
4. use it
```
cubridcmd           #show available commands
clone [cub]         #clone a cubrid repo; default cub
gen                 #generate project for current platform/OS (Linux: "Unix Makefiles", Windows: "Visual Studio 2017 Win64")
build               #build generated project
inst                #install
    
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
    cubrid-testtools
    cubrid-testtools-internal
    cubrid-testcases
    cubrid-testcases-private
    cubrid-testcases-private-ex
```
