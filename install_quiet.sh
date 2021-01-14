#!/bin/sh

WORK_DIR=work
DATA_DIR=data
CONFIG_TEMPLATE=config_template.py
CONFIG=config.py

base_dir=`(cd \`dirname $0\`; pwd)`
SCRIPT_NAME=`basename $0`

work_dir_abs="$base_dir/$WORK_DIR"
data_dir_abs="$base_dir/$DATA_DIR"

USAGE="Usage: ${SCRIPT_NAME} [-u]"

# Options
UNPRIVILEGED=false

while getopts u OPT; do
    case "${OPT}" in
        u)
            UNPRIVILEGED=true
            ;;
        \?)
            echo ${USAGE} 1>&2
            exit 1
            ;;
    esac
done
shift `expr $OPTIND - 1`

# Create directories

mkdir -p $work_dir_abs
mkdir -p $data_dir_abs

# Try to determine Apache group

apache_user=`ps aux | grep -v 'tomcat' | grep '[a]pache\|[h]ttpd' | cut -d ' ' -f 1 | grep -v '^root$' | head -n 1`
apache_group=`groups $apache_user | head -n 1 | sed 's/ .*//'`

# Make $work_dir_abs and $data_dir_abs writable by Apache

group_ok=0
if [ "${UNPRIVILEGED}" != 'true' -a -n "$apache_group" -a -n "$apache_user" ] ; then
    echo "Assigning owner of the following directories to apache ($apache_group):"
    echo "    \"$work_dir_abs/\""
    echo "and"
    echo "    \"$data_dir_abs/\""
    echo "(this requires sudo; please enter your password if prompted)"

    sudo chgrp -R $apache_group $data_dir_abs $work_dir_abs
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
	chmod -R g+rwx $data_dir_abs $work_dir_abs
	group_ok=1
    else
	echo "WARNING: failed to change group."
    fi
else
    echo "WARNING: failed to determine Apache group."
fi

if [ $group_ok -eq 0 ]; then
    echo
    echo "Setting global read and write permissions to directories"
    echo "    \"$work_dir_abs/\" and"
    echo "    \"$data_dir_abs/\""
    echo "(you may wish to consider fixing this manually)"
    chmod -R 777 $data_dir_abs $work_dir_abs
fi

# Extract the most important library dependencies.

( cd server/lib && tar xfz simplejson-2.1.5.tar.gz )

# Dump some last instructions to the user
echo 'The installation has finished, you are almost done.'
echo
echo '1.) If you are installing brat on a webserver, make sure you have '
echo '    followed the steps described in the brat manual to enable CGI:'
echo
echo '    http://brat.nlplab.org/installation.html'
echo
echo '2.) Please verify that brat is running by accessing your installation'
echo '    using a web browser.'
echo
echo 'You can automatically diagnose some common installation issues using:'
echo
echo '    tools/troubleshooting.sh URL_TO_BRAT_INSTALLATION'
echo
echo 'If there are issues not detected by the above script, please contact the'
echo 'brat developers and/or file a bug to the brat bug tracker:'
echo
echo '    https://github.com/nlplab/brat/issues'
echo
echo '3.) Once brat is running, put your data in the data directory. Or use'
echo '    the example data placed there by the installation:'
echo
echo "    ${data_dir_abs}"
echo
echo '4.) You can find configuration files to place in your data directory in'
echo '    the configurations directory, see the manual for further details:'
echo
echo "    ${base_dir}/configurations"
echo
echo '5.) Then, you (and your team?) are ready to start annotating!'