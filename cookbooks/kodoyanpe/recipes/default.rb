cache_path = Chef::Config[:file_cache_path]
remote_pkg_path = node['kodoyanpe']['pkg_path']
binary_kit_tarball = node['kodoyanpe']['binary_kit']
pkg_share_path = node['kodoyanpe']['pkg_share']

directory cache_path do
  recursive true
end

remote_file "#{cache_path}/#{binary_kit_tarball}" do
  source "#{remote_pkg_path}/#{binary_kit_tarball}"
  action :create_if_missing
end

execute "gzip -dc #{cache_path}/#{binary_kit_tarball} | /usr/sfw/bin/gtar -xf - -C /" do
  creates "/opt/omnibus/bootstrap/sbin"
end

directory pkg_share_path do
  recursive true
end

Array(node['kodoyanpe']['pkgsrc_pkgs']).each do |pkg|
  remote_file "#{pkg_share_path}/#{pkg}" do
    source "#{remote_pkg_path}/#{pkg}"
    action :create_if_missing
  end
end

%w{ruby193-base scmgit-base}.each do |pkg|
  execute "/opt/omnibus/bootstrap/sbin/pkg_add #{pkg} 2>&1 >/dev/null" do
    environment ({'PKG_PATH' => pkg_share_path})
    not_if "/opt/omnibus/bootstrap/sbin/pkg_info #{pkg} >/dev/null"
  end
end

user "kodoyanpe" do
  comment "Kodoyanpe User"
  shell "/usr/bin/bash"
  home "/export/home/kodoyanpe"
  supports ({:manage_home => true})
end

execute "usermod -P'Zone Management' kodoyanpe" do
  not_if "grep '^kodoyanpe:.*Zone Management' /etc/user_attr >/dev/null"
end

execute "zfs create #{node['kodoyanpe']['zone_pool']}/#{node['kodoyanpe']['zone_dataset']}" do
  not_if "zfs list | grep '#{node['kodoyanpe']['zone_pool']}/#{node['kodoyanpe']['zone_dataset']}' >/dev/null"
end

directory node['kodoyanpe']['zone_mountpoint'] do
  recursive true
  mode "0700"
end

execute "zfs set mountpoint=#{node['kodoyanpe']['zone_mountpoint']} #{node['kodoyanpe']['zone_pool']}/#{node['kodoyanpe']['zone_dataset']}" do
  not_if "zfs list | grep '#{node['kodoyanpe']['zone_mountpoint']}'"
  notifies :create, "directory[#{node['kodoyanpe']['zone_mountpoint']}]", :immediately
end

directory "/usr/share/zone-templates" do
  recursive true
end

remote_file "/usr/share/zone-templates/blerg" do
  source node['kodoyanpe']['master_zone_template']
  not_if { node['kodoyanpe']['master_zone_template'].nil? }
end

execute "ifconfig #{node['kodoyanpe']['test_network_interface']} plumb" do
  not_if "ifconfig #{node['kodoyanpe']['test_network_interface']}"
end

execute "ifconfig #{node['kodoyanpe']['test_network_interface']} inet #{node['kodoyanpe']['test_ip']} netmask #{node['kodoyanpe']['test_netmask']} up " do
  not_if "ifconfig #{node['kodoyanpe']['test_network_interface']} | grep 'inet #{node['kodoyanpe']['test_ip']} ' >/dev/null"
end

execute "set up nat" do
  not_if { false }
end

execute "set up nfs or lofs" do
  not_if { false }
end
