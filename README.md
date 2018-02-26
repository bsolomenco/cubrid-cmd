# cubrid-cmd (cubrid helper commands for bash)
works also on Windows via gitBash or Linux subsystem

1. choose a base folder
```
mkdir ~/cubrid
```
2. clone this repo in the previously created folder
```
git clone https://github.com/bsolomenco/cubrid-cmd ~/cubrid/cmd
```
3. make command avalable system-wide (one of the following ways)
  * 3.1. add to PATH
```
PATH += ~/cubrid/cmd
```
  * 3.2 make aliase(s) in ~/.bashrc (name them however you like)
<table>
  <tr>
     <th>example 1</th>
     <th>example 2</th>
  </tr>
  <tr>
     <td>
       <pre>
alias cubridcmd='~/cubrid/cubrid-cmd/cubridcmd.sh'
alias clone='cubridcmd clone'
alias gen='cubridcmd gen'
alias build='cubridcmd build'
alias build2='cubridcmd build2'
alias inst='cubridcmd inst'
alias db='cubridcmd db'
alias vg='cubridcmd vg'
       </pre>
     </td>
     <td>
       <pre>
alias cubridcmd='~/cubrid/cubrid-cmd/cubridcmd.sh'
alias c='cubridcmd clone'
alias g='cubridcmd gen'
alias b='cubridcmd build'
alias b2='cubridcmd build2'
alias i='cubridcmd inst'
alias d='cubridcmd db'
alias v='cubridcmd vg'
       </pre>
     </td>
  </tr>
</table>



4. use it
```
cd ~/cubrid
cubridcmd           #show available commands

clone [cub]         #clone a cubrid repo; default cub
gen                 #generate project for current platform/OS (Linux: "Unix Makefiles", Windows: "Visual Studio 2017 Win64")
build               #build generated project
inst [port]         #install and update ports; stop/kill cubrid processes before
db [name=testdb]    #generate database (default testdb)
clone tt [prefix]   #clone testtools, testtools-internal
clone tc [prefix]   #clone testcases, testcases-private, testcases-private-ex
```
5. resulting folder structure

<table>
  <tr>
     <th>default</th>
     <th>custom (with prefix="t" instead "cubrid-test")</th>
  </tr>
  <tr>
     <td>
       <pre>
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
       </pre>
     </td>
     <td>
       <pre>
         cubrid
             cmd
             repo
             build
             inst
             db
             ttools
             ttools-internal
             tcases
             tcases-private
             tcases-private-ex
       </pre>
     </td>
  </tr>
</table>
