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

FROM fedora:38 as samba
ENV SAMBA_ROOT /opt/camel/samba
EXPOSE 139 445
ADD smb.conf /etc/samba/smb.conf
ADD start.sh /usr/local/bin
RUN dnf install -y --setopt=tsflags=noman --setopt=install_weak_deps=False samba && mkdir -p /data/rw /data/ro && chmod +x /usr/local/bin/start.sh && dnf clean all
CMD /usr/local/bin/start.sh
