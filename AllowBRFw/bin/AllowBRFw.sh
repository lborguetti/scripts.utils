#!/bin/bash

ACTION=$1

export DIR_CFG=/opt/AllowBRFw/etc

#
# Load Confs
##
CFGS="AllowBRFw.cfg"
for cfg in ${CFGS}; do
   source ${DIR_CFG}/${cfg}
done

#
# Load Libs
##
LIBS="fw check lock help log"
for lib in ${LIBS}; do
    source ${DIR_LIB}/${lib}
done

#
# check current user - if != root && exit 9
##
unset RETURN
check_user root

if [ "${RETURN}"x != "0x" ] ; then
    help_erro_noroot
    exit 9
fi

#
# check environment - if erro && exit 19
##
unset RETURN
check_environment ${ACTION}

if [ "${RETURN}"x != "0x" ] ; then
    help_erro_environment
    help_usage
    exit 19
fi

case ${ACTION} in
    start)
        fw_start ;;
    stop)
        fw_stop ;;
    restart)
        fw_stop && fw_start ;;
    update)
        fw_update ;;
    *)
        help_usage ;;
esac
