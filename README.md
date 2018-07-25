# cubrid-cmd (cubrid helper commands for bash)
works also on Windows via gitBash or Linux subsystem

1. choose a base folder (eg. home folder)
```
cd ~
```
2. clone this repo in a subfolder
```
git clone https://github.com/bsolomenco/cubrid-cmd ~/cmd
```
3. set session environment (adjust aliases from cmd/env to your needs)
```
. cmd/env
```
4. use it
```
cubridcmd           #show available commands
clone [cub]         #clone a cubrid repo; default cub
gen                 #generate project for current platform/OS (Linux: "Unix Makefiles", Windows: "Visual Studio 2017 Win64")
build               #build generated project
inst [port]         #install and update ports; stop/kill cubrid processes before
db [name=testdb]    #generate database (default testdb)
clone tt [prefix]   #clone testtools, testtools-internal
clone tc [prefix]   #clone testcases, testcases-private, testcases-private-ex
```

mkdir cub
cd cub
clone; gen; build; inst
cd ~
clone tt t; clone tc t
test

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
