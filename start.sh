#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

echo "Creating read-writable files"
for file in $(seq 1 100) ; do
	echo ${RANDOM} > /data/rw/${file}.txt ;
done

echo "Creating read-only files"
for file in $(seq 1 100) ; do
	echo ${RANDOM} > /data/ro/${file}.txt ;
done

echo "Creating user camel..."
useradd camel

echo "Setting SMB password for camel..."
printf "camelTester123\ncamelTester123\n" | smbpasswd -s -a camel
if [ $? -eq 0 ]; then
	echo "SMB password set successfully"
else
	echo "ERROR: Failed to set SMB password"
	exit 1
fi

echo "Setting ownership of /data/rw..."
chown -Rv camel /data/rw

echo "Starting nmbd daemon..."
nmbd -D
if [ $? -eq 0 ]; then
	echo "nmbd started successfully"
else
	echo "ERROR: nmbd failed to start"
fi

echo "Starting smbd daemon..."
smbd -D -s /etc/samba/smb.conf --debuglevel=3
if [ $? -eq 0 ]; then
	echo "smbd started successfully"
else
	echo "ERROR: smbd failed to start"
fi

# Wait a moment for daemons to initialize
sleep 3

# Verify daemons are running
echo "Verifying daemons..."
if pgrep -x nmbd > /dev/null; then
	echo "✓ nmbd is running (PID: $(pgrep -x nmbd))"
else
	echo "✗ nmbd is NOT running"
fi

if pgrep -x smbd > /dev/null; then
	echo "✓ smbd is running (PID: $(pgrep -x smbd))"
else
	echo "✗ smbd is NOT running"
fi

echo "SMB server initialization complete"

while true ; do
	sleep 10
done