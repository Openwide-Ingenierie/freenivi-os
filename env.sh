BASE=`pwd`
unset LC_ALL
export LC_ALL 
export LANG=en_US.UTF-8 
export PATH=${BASE}/src/oe-core/scripts:${BASE}/src/bitbake/bin:$PATH
export BUILDDIR=${BASE}

# Shutdown any bitbake server if the BBSERVER variable is not set
if [ -z "$BBSERVER" ] && [ -f bitbake.lock ] ; then
    grep ":" bitbake.lock > /dev/null && BBSERVER=`cat bitbake.lock` bitbake --status-only
    if [ $? = 0 ] ; then
	echo "Shutting down bitbake memory resident server with bitbake -m"
	BBSERVER=`cat bitbake.lock` bitbake -m
    fi
fi
