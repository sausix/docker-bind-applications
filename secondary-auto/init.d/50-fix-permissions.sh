#!/bin/sh +e

if [ "${BIND_FIX_PERMISSIONS}" != "no" ]; then
	echo "Resetting permissions..."
	
	if touch "/etc/bind/.tmp" 2> /dev/null && rm "/etc/bind/.tmp"; then
		# /etc/bind
		chown root:named /etc/bind
		chmod 0750 /etc/bind
		
		chown root:named /etc/bind/*.conf
		chmod 0644 /etc/bind/*.conf

		# /etc/bind/rndc.key
		if [ -f /etc/bind/rndc.key ]; then
			chown named:named /etc/bind/rndc.key
			chmod 0600 /etc/bind/rndc.key
		fi
	else
		echo "/etc/bind is read only. Skipping."
	fi
	
	# /var/named
	chown -R named:named /var/named
	chmod 0770 /var/named

	chmod 0640 /var/named/*
fi

echo "Done."
exit 0
