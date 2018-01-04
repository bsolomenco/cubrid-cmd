#================================================================
#scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#printf "DBG scriptDir = $scriptDir \n"

#================================================================
helpFunc () {
    printf ".\\s [command [args]]\n"
    printf "    clone [repository]\n"
    printf "        cub  = cubrid                                 ==> repo\n"
    printf "        tt   = cubrid testtools, -internal            ==> tt, tti\n"
    printf "        tc   = cubrid-testcase, -private, -private-ex ==> tc, tcp, tcpe\n"
    printf "    gen   = generate|configure cubrid                 ==> build\n"
    printf "    build = build cubrid"
    printf "    inst  = install cubrid                            ==> inst (backup conf/*.conf before and restore after)\n"

    printf "    %-10s %s\n" "genDb"     "generate testdb ==> \"$scriptDir/db\""
    printf "    %-10s %s\n" "cloneTst"  "clone test tools and cases:"
    printf "    %-10s %s\n" "    cubrid-testtools             ==> \"$scriptDir/tt\""
    printf "    %-10s %s\n" "    cubrid-testtools-internal    ==> \"$scriptDir/tt-internal\""
    printf "    %-10s %s\n" "    cubrid-testtestcases         ==> \"$scriptDir/tc\""
    printf "    %-10s %s\n" "    cubrid-testtestcases-private ==> \"$scriptDir/tc-private\""
    printf "    %-10s %s\n" "vg"        "valgrind ..."
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
            chkCmd "git merge upstream/develop"
            chkCmd "popd"
            ;;
        tt)
            runCmd "rm -rf tt"
            chkCmd "git clone https://github.com/CUBRID/cubrid-testtools tt"
            runCmd "rm -rf tti"
            chkCmd "git clone https://github.com/CUBRID/cubrid-testtools-internal tti"
            ;;
        tc)
            runCmd "rm -rf tc"
            chkCmd "git clone https://github.com/CUBRID/cubrid-testcases tc"
            runCmd "rm -rf tcp"
            chkCmd "git clone https://github.com/CUBRID/cubrid-testcases-private tcp"
            runCmd "rm -rf tcpe"
            chkCmd "git clone https://github.com/CUBRID/cubrid-testcases-private-ex tcpe"
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
    chkCmd "cp inst/conf/cubrid.conf            inst/conf/cubrid.conf.bak"
    chkCmd "cp inst/conf/cubrid_broker.conf     inst/conf/cubrid_broker.conf.bak"
    chkCmd "cp inst/conf/cubrid_ha.conf         inst/conf/cubrid_ha.conf.bak"

    chkCmd "pushd build"
    chkCmd "cmake --build . --target install"
    chkCmd "popd"

    printf "DBG restore configuration files...\n"
    chkCmd "mv inst/conf/cubrid.conf.bak        inst/conf/cubrid.conf"
    chkCmd "mv inst/conf/cubrid_broker.conf.bak inst/conf/cubrid_broker.conf"
    chkCmd "mv inst/conf/cubrid_ha.conf.bak     inst/conf/cubrid_ha.conf"
}

#================================================================
genDbFunc () {
    runCmd "rm -rf $scriptDir/db"
    chkCmd "mkdir $scriptDir/db"
    chkCmd "pushd $scriptDir/db"
    runCmd "cubrid server stop testdb"
    runCmd "cubrid deletedb testdb"
    chkCmd "cubrid createdb testdb en_US"
    chkCmd "cubrid server start testdb"
    chkCmd "cubrid service status"
    chkCmd "cubrid server stop testdb"
    #csql -S testdb
    chkCmd "cubrid service status"
    chkCmd "popd"
}

#================================================================
cloneTstFunc () {
    runCmd "rm -rf $scriptDir/tt"
    chkCmd "git clone https://github.com/CUBRID/cubrid-testtools $scriptDir/tt"
    runCmd "rm -rf $scriptDir/tt-internal"
    chkCmd "git clone https://github.com/CUBRID/cubrid-testtools-internal $scriptDir/tt-internal"
    runCmd "rm -rf $scriptDir/tc"
    chkCmd "git clone https://github.com/CUBRID/cubrid-testcases $scriptDir/tc"
    runCmd "rm -rf $scriptDir/tc-private"
    chkCmd "git clone https://github.com/CUBRID/cubrid-testcases $scriptDir/tc-private"
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