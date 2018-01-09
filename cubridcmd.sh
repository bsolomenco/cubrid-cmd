#!/bin/bash

#================================================================
#scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#printf "DBG scriptDir = $scriptDir \n"

#================================================================
helpFunc () {
    printf "./cubridcmd.sh [command [args]]\n"
    printf "    clone [repository=cub]\n"
    printf "        cub         = cubrid                            ==> repo\n"
    printf "        tt [prefix=cubrid-test] = cubrid -tools, -tools-internal\n"
    printf "        tc [prefix=cubrid-test] = cubrid -cases, -cases-private, -cases-private-ex\n"
    printf "    gen                     = generate|configure cubrid ==> build\n"
    printf "    build                   = build cubrid\n"
    printf "    inst                    = install cubrid, update config files ==> inst\n"
    printf "    genDb [database=testdb] = cubrid createdb testdb    ==> db\n"
    printf "    vg                      = valgrind ..."
    printf "    ports                   = set ports\n"
}

#================================================================
runCmd () {
    #echo "TR0 $@"; eval "$@"; local rc=$?
    echo "TR0 $@"
    eval "$@"
    local rc=$?
    return $rc
}

#================================================================
chkCmd () {
    runCmd "$@"
    local rc=$?
    if [ $rc -ne 0 ]
    then
        echo "ERR $rc $@"
        exit $rc
    fi
}

#================================================================
cloneFunc () {
    #1st arg is the repository alias
    local repo=${1:-cub} #default repo alias is cub
    case ${repo} in
        cub)
            runCmd "rm -rf repo"
            chkCmd "git clone https://github.com/bsolomenco/cubrid repo"
            chkCmd "pushd repo"
            chkCmd "git remote add upstream https://github.com/CUBRID/cubrid"
            chkCmd "git remote -v"
            chkCmd "git fetch"
            chkCmd "git fetch upstream"
            #chkCmd "git merge upstream/develop"
            chkCmd "popd"
            ;;
        tt)
            local prefix="${2:-cubrid-test}"
            runCmd "rm -rf ${prefix}tools"
            chkCmd "git clone https://github.com/CUBRID/cubrid-testtools ${prefix}tools"
            runCmd sed -i -e "s:web_port=.*:web_port=1950:"                                 ${prefix}tools/CTP/conf/webconsole.conf
            runCmd sed -i -e "s:scenario=.*:scenario=${HOME}/cubrid/${prefix}cases/sql:"    ${prefix}tools/CTP/conf/sql.conf
            runCmd sed -i -e "s:cubrid_port_id=.*:cubrid_port_id=1973:"                     ${prefix}tools/CTP/conf/sql.conf
            runCmd sed -i -e "s:MASTER_SHM_ID=.*:MASTER_SHM_ID=1973:"                       ${prefix}tools/CTP/conf/sql.conf
            runCmd sed -i -e "s:BROKER_PORT=.*:BROKER_PORT=1975:"                           ${prefix}tools/CTP/conf/sql.conf
            runCmd sed -i -e "s:APPL_SERVER_SHM_ID=.*:APPL_SERVER_SHM_ID=1975:"             ${prefix}tools/CTP/conf/sql.conf
            runCmd sed -i -e "s:ha_port_id=.*:ha_port_id=1976:"                             ${prefix}tools/CTP/conf/sql.conf
            runCmd sed -i -e "s:scenario=.*:scenario=${HOME}/cubrid/${prefix}cases/medium:" ${prefix}tools/CTP/conf/medium.conf
            runCmd sed -i -e "s:cubrid_port_id=.*:cubrid_port_id=1973:"                     ${prefix}tools/CTP/conf/medium.conf
            runCmd sed -i -e "s:MASTER_SHM_ID=.*:MASTER_SHM_ID=1973:"                       ${prefix}tools/CTP/conf/medium.conf
            runCmd sed -i -e "s:BROKER_PORT=.*:BROKER_PORT=1975:"                           ${prefix}tools/CTP/conf/medium.conf
            runCmd sed -i -e "s:APPL_SERVER_SHM_ID=.*:APPL_SERVER_SHM_ID=1975:"             ${prefix}tools/CTP/conf/medium.conf
            runCmd sed -i -e "s:ha_port_id=.*:ha_port_id=1976:"                             ${prefix}tools/CTP/conf/medium.conf

            #runCmd "rm -rf ${prefix}tools-internal"
            #chkCmd "git clone https://github.com/CUBRID/cubrid-testtools-internal ${prefix}tools-internal"
            ;;
        tc)
            local prefix="${2:-cubrid-test}"
            runCmd "rm -rf ${prefix}cases"
            chkCmd "git clone https://github.com/CUBRID/cubrid-testcases ${prefix}cases"
            runCmd "rm -rf ${prefix}cases-private"
            chkCmd "git clone https://github.com/CUBRID/cubrid-testcases-private ${prefix}cases-private"
            runCmd "rm -rf ${prefix}cases-private-ex"
            chkCmd "git clone https://github.com/CUBRID/cubrid-testcases-private-ex ${prefix}cases-private-ex"
            ;;
        *)
            printf "ERR unknown repository: ${repo}\nSYNTAX: clone <repository>\n"
            ;;
    esac
}

#================================================================
genFunc () {
    local generator=${1:-'"Unix Makefiles"'}
    case ${OSTYPE} in
        linux*) #assume Linux
            printf "DBG platform/OS: ${OSTYPE}\n"
            local generator='"Unix Makefiles"'
            ;;
        msys*) #assume mingw on Windows
            printf "DBG platform/OS: ${OSTYPE}\n"
            local generator='"Visual Studio 15 2017 Win64"'
            ;;
        *)
            printf "ERR unknown platform/OS: ${OSTYPE}\n"
            ;;
    esac
    runCmd "rm -rf build"
    chkCmd "mkdir build"
    chkCmd "pushd build"
    chkCmd "cmake -G $generator -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=../inst -DUNIT_TESTS=ON ../repo"
    chkCmd "popd"
}

#================================================================
buildFunc () {
    chkCmd "pushd build"
    chkCmd "cmake --build ."
    chkCmd "popd"
}

#================================================================
instFunc () {
    printf "DBG backup configuration files...\n"
    runCmd "cp inst/conf/cubrid_ha.conf         ."

    chkCmd "pushd build"
    chkCmd "cmake --build . --target install"
    chkCmd "popd"

    runCmd sed -i "/^\[common\]/        , /\[/{s/^cubrid_port_id[ ]*=[ ]*.*/cubrid_port_id=1973/}"         inst/conf/cubrid.conf
    runCmd sed -i "/^\[broker\]/        , /\[/{s/^MASTER_SHM_ID[ ]*=[ ]*.*/MASTER_SHM_ID=1973/}"           inst/conf/cubrid_broker.conf
    runCmd sed -i "/^\[%query_editor\]/ , /\[/{s/^BROKER_PORT[ ]*=[ ]*.*/BROKER_PORT=1974/}"               inst/conf/cubrid_broker.conf
    runCmd sed -i "/^\[%query_editor\]/ , /\[/{s/^APPL_SERVER_SHM_ID[ ]*=[ ]*.*/APPL_SERVER_SHM_ID=1974/}" inst/conf/cubrid_broker.conf
    runCmd sed -i "/^\[%BROKER1\]/      , /\[/{s/^BROKER_PORT[ ]*=[ ]*.*/BROKER_PORT=1975/}"               inst/conf/cubrid_broker.conf
    runCmd sed -i "/^\[%BROKER1\]/      , /\[/{s/^APPL_SERVER_SHM_ID[ ]*=[ ]*.*/APPL_SERVER_SHM_ID=1975/}" inst/conf/cubrid_broker.conf

    printf "DBG restore configuration files...\n"
    runCmd "mv cubrid_ha.conf     inst/conf/"
}

#================================================================
genDbFunc () {
    local db=${1:-testdb}
    runCmd "rm -rf db"
    runCmd "mkdir db"
    chkCmd "pushd db"
    runCmd "cubrid server stop ${db}"
    runCmd "cubrid deletedb ${db}"
    chkCmd "cubrid createdb ${db} en_US"
    chkCmd "cubrid server start ${db}"
    chkCmd "cubrid service status"
    chkCmd "cubrid server stop ${db}"
    #csql -S testdb
    chkCmd "cubrid service status"
    chkCmd "popd"
}

#================================================================
vgFunc () {
    #chkCmd "valgrind --trace-children=yes --log-file=$HOME/cubrid/vg/broker_%p.txt --xml=yes --xml-file=$HOME/cubrid/vg/broker_%p.xml --leak-check=full --error-limit=no --num-callers=50 $@"
    chkCmd "valgrind --log-file=vg.txt --leak-check=full --trace-children=yes --track-origins=yes --error-limit=no --num-callers=50 $@"
}

#================================================================
dt0=$(date +"%Y-%m-%d %H:%M:%S")

#consider 1st arg as command and execute it with th rest of args
cmd=${1:-help} #default command is help
eval "${cmd}""Func" "${@:2}"

dt1=$(date +"%Y-%m-%d %H:%M:%S")

printf "================================================================ SUMMARY\n"
#printf "DBG scriptDir = $scriptDir \n"
printf "TIM %s\nTIM %s\n" "$dt0" "$dt1"
