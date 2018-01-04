#================================================================
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
printf "DBG scriptDir = $scriptDir \n"

#================================================================
helpFunc () {
    printf ".\\s [command [args]]\n"
    printf "    %-10s %s\n" "cloneCub"  "clone CUBRID ==> \"$scriptDir/repo\""
    printf "    %-10s %s\n" "genCub"    "generate cubrid ==> \"$scriptDir/build\""
    printf "    %-10s %s\n" "buildCub"  "build cubrid"
    printf "    %-10s %s\n" "instCub"   "install cubrid ==> \"$scriptDir/inst\" (backup conf/*.conf before and restore after)"
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
cloneCubFunc () {
    runCmd "rm -rf $scriptDir/repo"
    chkCmd "git clone https://github.com/bsolomenco/cubrid $scriptDir/repo"
    chkCmd "pushd $scriptDir/repo"
    chkCmd "git remote add upstream https://github.com/CUBRID/cubrid"
    chkCmd "git remote -v"
    chkCmd "git fetch"
    chkCmd "git fetch upstream"
    chkCmd "git merge upstream/develop"
    chkCmd "popd"
}

#================================================================
genCubFunc () {
    runCmd "rm -rf $scriptDir/build"
    chkCmd "mkdir $scriptDir/build"
    chkCmd "pushd $scriptDir/build"
    local generator='"Unix Makefiles"'
    chkCmd "cmake -G $generator -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=../inst -DUNIT_TESTS=ON $scriptDir/repo"
    chkCmd "popd"
}

#================================================================
buildCubFunc () {
    chkCmd "pushd $scriptDir/build"
    chkCmd "cmake --build ."
    chkCmd "popd"
}

#================================================================
instCubFunc () {
    printf "DBG backup configuration files...\n"
    chkCmd "cp $CUBRID/conf/cubrid.conf            $CUBRID/conf/cubrid.conf.bak"
    chkCmd "cp $CUBRID/conf/cubrid_broker.conf     $CUBRID/conf/cubrid_broker.conf.bak"
    chkCmd "cp $CUBRID/conf/cubrid_ha.conf         $CUBRID/conf/cubrid_ha.conf.bak"

    chkCmd "pushd $scriptDir/build"
    chkCmd "cmake --build . --target install"
    chkCmd "popd"

    printf "DBG restore configuration files...\n"
    chkCmd "mv $CUBRID/conf/cubrid.conf.bak        $CUBRID/conf/cubrid.conf"
    chkCmd "mv $CUBRID/conf/cubrid_broker.conf.bak $CUBRID/conf/cubrid_broker.conf"
    chkCmd "mv $CUBRID/conf/cubrid_ha.conf.bak     $CUBRID/conf/cubrid_ha.conf"
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
cmd=${1:-help}
eval "${cmd}""Func" "${@:2}"

dt1=$(date +"%Y-%m-%d %H:%M:%S")

printf "================================================================ SUMMARY\n"
printf "DBG scriptDir = $scriptDir \n"
printf "TIM %s\nTIM %s\n" "$dt0" "$dt1"