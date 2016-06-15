#!/bin/bash

SWCON=~/shopware/bin/console
SWCCLEAR=~/shopware/var/cache/clear_cache.sh
LOGFILE=~/shopware/var/log/foobarlogger.log
PREVLOG=~/shopware/var/log/prev_foobarlogger.log
BPLUGS=(FoobarLogger PluginManager)

function printActivePlugins
{
	$SWCON sw:plugin:list --filter=active \
		| tail -n +4 \
		| head -n -1 \
		| sed -r "s/^\| ([^ ]+).*$/\\1/"
}

function deactivatePlugin
{
	local plugin=$1
	$SWCON sw:plugin:deactivate $plugin
	$SWCON sw:theme:cache:generate
}

function doWorkLol
{
	rm $LOGFILE
	xvfb-run python3 /vagrant/test-case.py
	sleep 1
	if [[ -e $PREVLOG ]]; then
		diff -u $PREVLOG $LOGFILE
	else
		cat $LOGFILE
	fi
	cp $LOGFILE $PREVLOG
}

rm $PREVLOG
echo "======================================================================="
echo "Initial log"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
doWorkLol

for plugin in $(printActivePlugins); do
	if [[ " ${BPLUGS[@]} " =~ " ${plugin} " ]]; then
		continue
	fi
	echo "======================================================================="
	deactivatePlugin $plugin
	echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	doWorkLol
done
