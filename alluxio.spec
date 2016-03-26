# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.



Name:           alluxio-tfs
#this is used for the rpm name
%define 	alluxio_version 0.6.0
%define		alluxio_release 1%{?dist}
Version:        %{alluxio_version}
Release:        %{alluxio_release}
Summary:       Reliable file sharing at memory speed across cluster frameworks
License:       ASL 2.0
URL:           http://tachyon-project.org/
Group:         Development/Libraries
BuildArch:     noarch

Source0:       v0.6.0.tar.gz
Source1:       do-component-build
Source2:       install_alluxio.sh
Source3:       init.d.tmpl
Source4:       alluxio-master.svc
Source5:       alluxio-worker.svc
%define        alluxio_name alluxio
%define        alluxio_home /usr/lib/%{alluxio_name}
%define        alluxio_services master worker
%define        var_lib /var/lib/alluxio
%define        var_run /var/run/alluxio
%define        var_log /var/log/alluxio

%global        initd_dir %{_sysconfdir}/init.d

%if  %{?suse_version:1}0
# Required for init scripts
Requires: insserv
%global        initd_dir %{_sysconfdir}/rc.d

%else
# Required for init scripts
Requires: /lib/lsb/init-functions

%global        initd_dir %{_sysconfdir}/rc.d/init.d

%endif

Requires: bigtop-utils

# disable repacking jars
%define __arch_install_post %{nil}
%define debug_package %{nil}

%description
Tachyon is a fault tolerant distributed file system
enabling reliable file sharing at memory-speed
across cluster frameworks, such as Spark and MapReduce.
It achieves high performance by leveraging lineage
information and using memory aggressively.
Tachyon caches working set files in memory, and
enables different jobs/queries and frameworks to
access cached files at memory speed. Thus, Tachyon
avoids going to disk to load data-sets that
are frequently read.

%prep
%setup -n alluxio-0.6.0

%build
bash $RPM_SOURCE_DIR/do-component-build

%install
rm -rf $RPM_BUILD_ROOT

# See /usr/lib/rpm/macros for info on how vars are defined.
# Here we run the alluxio installation script.
bash %{SOURCE2} \
    --build-dir=%{buildroot} \
    --bin-dir=%{_bindir} \
    --data-dir=%{_datadir} \
    --libexec-dir=%{_libexecdir} \
    --var-dir=%{_var}  \
    --prefix="${RPM_BUILD_ROOT}"

for service in %{alluxio_services}
do
    # Install init script
    init_file=$RPM_BUILD_ROOT/%{initd_dir}/%{alluxio_name}-${service}
    bash $RPM_SOURCE_DIR/init.d.tmpl $RPM_SOURCE_DIR/alluxio-${service}.svc rpm $init_file
done

%preun
for service in %{alluxio_services}; do
  /sbin/service %{alluxio_name}-${service} status > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    /sbin/service %{alluxio_name}-${service} stop > /dev/null 2>&1
  fi
done


%files
%defattr(-,root,root,-)
%doc LICENSE README.md
%dir %{_sysconfdir}/%{alluxio_name}
%config(noreplace) %{_sysconfdir}/%{alluxio_name}/conf/log4j.properties
%config(noreplace) %{_sysconfdir}/%{alluxio_name}/conf/workers
%config(noreplace) %{initd_dir}/%{alluxio_name}-master
%config(noreplace) %{initd_dir}/%{alluxio_name}-worker
%config(noreplace) %{_sysconfdir}/%{alluxio_name}/conf/alluxio-env.sh
%config(noreplace) %{alluxio_home}/libexec/alluxio-layout.sh
%attr(0755,root,root) %{var_lib}
%attr(0755,root,root) %{var_run}
%attr(0755,root,root) %{var_log}
%{alluxio_home}/alluxio*
%{alluxio_home}/bin/alluxio*
%{alluxio_home}/libexec/alluxio*
#%{_datadir}/%{alluxio_name}/usr/bin/alluxio
%{alluxio_home}/share

%clean
echo "should no clean here!!!!!!!"

%changelog
* Thu Mar 05 2015 Huamin Chen
- upgrade to Tachyon 0.6.0
