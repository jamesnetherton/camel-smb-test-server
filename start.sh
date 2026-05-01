#!/bin/bash

# Configure SMB credentials from environment variables
# These MUST be provided - no defaults for security
if [ -z "${SMB_USER}" ] || [ -z "${SMB_PASSWORD}" ]; then
	echo "ERROR: SMB credentials not provided!"
	echo ""
	echo "You must set both SMB_USER and SMB_PASSWORD environment variables."
	echo ""
	echo "Example:"
	echo "  docker run -e SMB_USER=testuser -e SMB_PASSWORD=secret123 ..."
	echo ""
	echo "For security reasons, this server does NOT have default credentials."
	exit 1
fi

SMB_USER="${SMB_USER}"
SMB_PASSWORD="${SMB_PASSWORD}"

echo "Creating read-writable files"
for file in $(seq 1 100) ; do
	echo ${RANDOM} > /data/rw/${file}.txt ;
done

echo "Creating read-only files"
for file in $(seq 1 100) ; do
	echo ${RANDOM} > /data/ro/${file}.txt ;
done

echo "Creating user and groups..."
useradd -M -s /sbin/nologin "${SMB_USER}"

echo "Setting SMB password for ${SMB_USER}..."
(echo "${SMB_PASSWORD}"; echo "${SMB_PASSWORD}") | smbpasswd -s -a "${SMB_USER}"
if [ $? -eq 0 ]; then
	echo "SMB password set successfully"
	# Explicitly enable the user
	smbpasswd -e "${SMB_USER}"
	echo "SMB user enabled"
else
	echo "ERROR: Failed to set SMB password"
	exit 1
fi

echo "Setting ownership of /data/rw..."
chown -Rv "${SMB_USER}" /data/rw

echo "Configuring Samba shares for user ${SMB_USER}..."
sed -i "s/valid users = .*/valid users = ${SMB_USER}/g" /etc/samba/smb.conf

echo "Starting SMB daemons..."
nmbd -D
smbd -D -s /etc/samba/smb.conf

# Give daemons a moment to start
sleep 2

# Check if they're running
if pgrep -x nmbd > /dev/null; then
	echo "✓ nmbd is running"
else
	echo "✗ nmbd is NOT running"
	nmbd --foreground --no-process-group --debuglevel=5 -s /etc/samba/smb.conf 2>&1 &
	sleep 5
	exit 1
fi

if pgrep -x smbd > /dev/null; then
	echo "✓ smbd is running"
else
	echo "✗ smbd is NOT running - trying foreground mode for debugging"
	smbd --foreground --no-process-group --debuglevel=5 -s /etc/samba/smb.conf 2>&1
	exit 1
fi

echo "✅ SMB server is ready"
echo
echo "=================================================="
echo "⚠️  WARNING: TEST SERVER - NOT FOR PRODUCTION  ⚠️"
echo "=================================================="
echo

# Keep container running
while true; do
	sleep 10
done
