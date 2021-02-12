#!/bin/sh +e

KEY="/etc/bind/rndc.key"
CONF="/etc/bind/rndc.conf"
INCLUDE="/etc/bind/named.rndc.conf"

# At least  and empty file to nor break includes in config
touch "$INCLUDE"


if [ "${RNDC_KEY_GENERATE}" != "no" ] && touch "/etc/bind/.tmp" 2> /dev/null && rm "/etc/bind/.tmp" && [ ! -f "$KEY" ] || [ ! -f "$CONFIG" ] || [ "${RNDC_KEY_GENERATE}" = "yes" ]; then
	echo "Creating rndc-key..."
	/usr/local/sbin/rndc-confgen -a
	chown root:named "${KEY}"
	chmod 0640 "${KEY}"

	if [ "${RNDC_CONF_CREATE}" = "yes" ]; then
		# Create optional rndc config with key
		cp -p "$KEY" "$CONF"
		cat >> "$CONF" << 'EOF'

options {
	default-key "rndc-key";
	default-server 127.0.0.1;
	default-port 953;
};
EOF
	fi
fi

if [ "${ALLOW_RNDC}" = "yes" ]; then
	# Create named config for including rndc access

	if [ -f "$KEY" ]; then
		# Key exists
		cp -p "$KEY" "$INCLUDE"
		cat >> "$INCLUDE" << 'EOF'

controls {
	inet 127.0.0.1 port 953
	allow { 127.0.0.1; } keys { "rndc-key"; };
};
EOF
	else
		# Key missing
		echo "Missing 'rndc.key' file. May be enable by setting RNDC_KEY_GENERATE to 'yes' to generate it."
		echo "rndc access will be disabled."
		echo "# rndc access disabled by create-rndc-key.sh because of missing rndc.key." > "$INCLUDE"
	fi
else
	echo "# rndc access disabled by create-rndc-key.sh because ALLOW_RNDC was not set to 'yes'." > "$INCLUDE"
fi


chown root:named "${INCLUDE}"
chmod 0640 "${INCLUDE}"

echo "Done."
exit 0
