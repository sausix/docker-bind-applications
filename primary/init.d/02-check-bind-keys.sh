#!/bin/sh +e

BIND_KEYS_FILE=${BIND_KEYS_FILE:-/etc/bind/bind.keys}

if [ "${BIND_KEYS_ACQUIRE}" != "no" ] && [ ! -f "/etc/bind/bind.keys" ] || [ "${BIND_KEYS_ACQUIRE}" = "yes" ]; then
	if touch "/etc/bind/.tmp" 2> /dev/null && rm "/etc/bind/.tmp"; then
		echo "Fetching bind-keys..."
		wget -O "${BIND_KEYS_FILE}" "${BIND_KEYS_URL:-https://ftp.isc.org/isc/bind9/keys/9.11/bind.keys.v9_11}"
		chown root:named "${BIND_KEYS_FILE}"
		chmod 0644 "${BIND_KEYS_FILE}"
	else
		echo "/etc/bind is read only. Skipping."
	fi
fi

echo "Done."
exit 0
