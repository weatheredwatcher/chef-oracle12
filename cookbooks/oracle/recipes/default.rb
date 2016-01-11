execute 'Update YUM' do
  command 'yum update -y'
end

### Install dependencies
package "unzip"
package "binutils"
package "compat-libcap1"
package "compat-libstdc++-33"
package "compat-libstdc++-33.i686"
package "gcc"
package "gcc-c++"
package "glibc.i686"
package "glibc"
package "glibc-devel"
package "glibc-devel.i686"
package "ksh"
package "libgcc.i686"
package "libgcc"
package "libstdc++"
package "libstdc++.i686"
package "libstdc++-devel"
package "libstdc++-devel.i686"
package "libaio"
package "libaio.i686"
package "libaio-devel"
package "libaio-devel.i686"
package "libXext"
package "libXext.i686"
package "libXtst"
package "libXtst.i686"
package "libX11"
package "libX11.i686"
package "libXau"
package "libXau.i686"
package "libxcb"
package "libxcb.i686"
package "libXi"
package "libXi.i686"
package "make"
package "sysstat"
package "vte3"
package "smartmontools"


execute 'setup users and groups' do
  command 'groupadd -g 54321 oinstall && groupadd -g 54322 dba'
  command 'userdel vagrant && rm -rf /home/vagrant && rm /var/spool/mail/oracle'
  command 'useradd -m -u 54321 -g oinstall -G dba vagrant'
  command 'echo "oracle:oracle" | chpasswd'
end


execute 'setup env' do

  ENV['ORACLE_BASE'] = "/u01/app/oracle"
  ENV['CVUQDISK_GRP'] = "oinstall"

end
execute 'extract oracle 12 1 of 2' do
  command 'unzip linuxamd64_12102_database_1of2.zip'
  cwd '/vagrant/manifest'
end

execute 'extract oracle 12 2 of 2' do
  command 'unzip linuxamd64_12102_database_2of2.zip'
  cwd '/vagrant/manifest'
end

directory '/u01/app/oracle' do
  owner 'oinstall'
  group 'oinstall'
  mode '0755'
  action :create
end

directory '/u01/app/oraInventory' do
  owner 'vagrant'
  group 'root'
  mode '0755'
  action :create
end


file '/etc/oraInst.loc' do

  action :create
end

file '/etc/security/limits.conf' do

  content 'oracle soft stack 10240'
end
## install RPM's

execute 'Install RPMs' do
  command 'rpm -iv cvuqdisk-1.0.9-1.rpm'
  cwd '/vagrant/manifest/database/rpm'
end

##install Oracle 12
#

file '/tmp/db_install.rsp' do
  action :create
end

execute 'Install Oracle 12' do
  command './runInstaller -ignoreSysPrereqs -ignorePrereq -silent -noconfig -responseFile /tmp/db_install.rsp'
  cwd '/vagrant/manifest/database'
end

