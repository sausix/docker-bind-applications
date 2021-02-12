#!/bin/sh +e

if [ "${APPLY_CONFIG}" = "no" ]; then
	echo "Disabled by env APPLY_CONFIG."
	exit 0
fi

#############################
# /var/named

if [ "${APPLY_VAR_CLEAN}" == "yes" ]; then
	echo "Cleaning up '/var/named' before applying static config..."
	rm -rf /var/named/* 2> /dev/null
else
	echo "Just overwriting files in '/var/named'."
	echo "Orphaned files may result but should not interfere."
fi

echo "Copy default zone files ..."
cp ${CONTAINER_DIR}/default-zones/*.zone /var/named/ 2> /dev/null

echo "Copy static zone files ..."
cp ${CONTAINER_DIR}/bind-config/*.zone /var/named/ 2> /dev/null



#############################
# /etc/bind

if [ "${APPLY_CONFIG_CLEAN}" == "yes" ]; then
	echo "Cleaning up '/etc/bind' before applying static config ..."
	rm -rf /etc/bind/* 2> /dev/null
else
	echo "Just overwriting files in '/etc/bind'."
	echo "Orphaned files may result but should not interfere."
fi

echo "Copy static conf to /etc/bind/ ..."
cp ${CONTAINER_DIR}/bind-config/*.conf /etc/bind/ 2> /dev/null

echo "Copy keys like rndc.key to /etc/bind/ ..."
cp ${CONTAINER_DIR}/bind-config/*.key* /etc/bind/ 2> /dev/null



#############################
# ToDo: Scripting
echo "Done."
exit 0
