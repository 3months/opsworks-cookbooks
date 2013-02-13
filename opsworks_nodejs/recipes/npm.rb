remote_file "/tmp/npm-#{node[:opsworks_nodejs][:npm_version]}.tgz" do
  source "#{node[:opsworks_commons][:assets_url]}/sources/npm/npm-#{node[:opsworks_nodejs][:npm_version]}.tgz"
  action :create_if_missing
end

directory "/tmp/npm-#{node[:opsworks_nodejs][:npm_version]}"
execute "tar xvfz /tmp/npm-#{node[:opsworks_nodejs][:npm_version]}.tgz -C /tmp/npm-#{node[:opsworks_nodejs][:npm_version]} --strip-components=1"

execute "Install npm #{node[:opsworks_nodejs][:npm_version]}" do
  cwd "/tmp/npm-#{node[:opsworks_nodejs][:npm_version]}"
  command 'make install'
  not_if do
    ::File.exists?("/usr/local/bin/npm") &&
    system("/usr/local/bin/npm -v | grep -q '#{node[:opsworks_nodejs][:npm_version]}'")
  end
end
