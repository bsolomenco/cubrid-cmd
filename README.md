# cubrid-cmd (cubrid helper commands for bash)
works also on Windows via gitBash or Linux subsystem

1. choose a base folder (eg. home folder)
```
cd ~
```
2. clone this repo in a subfolder
```
git clone https://github.com/bsolomenco/cubrid-cmd ~/cub-cmd
```
3. set session environment (adjust aliases from cmd/env to your needs)
```
. cub-cmd/env
```
4. use it
```
cubridcmd           #shows available commands

mkdir cub
cd cub
clone; gen; build; inst
cd ~
clone tt; clone tc
test
```

5. resulting folder structure

<table>
  <tr>
     <td>
       <pre>
         cmd
         cub
             repo
             build
         cubrid
         db
         ttools
         tcases
       </pre>
     </td>
     <td>
       <pre>
         (cubrid-cmd clone)
         (development version)
         (cubrid clone)
         (build folder)
         (installation)
         (databases)
         (cubrid-testtools)
         (cubrid-testcases)
       </pre>
     </td>
  </tr>
</table>
