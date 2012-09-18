include_recipe 'apache2::service'
include_recipe 'scalarium_ganglia::service-gmetad'

template "/etc/ganglia/gmetad.conf" do
  source "gmetad.conf.erb"
  mode '0644'
  variables :cluster_name => node[:scalarium][:cluster][:name]
  notifies :restart, resources(:service => "gmetad")
end

template "/usr/share/ganglia-webfrontend/conf.php" do
  source "conf.php.erb"
  mode '0644'
end

directory "/etc/ganglia-webfrontend" do
  mode '0755'
end

execute "Update htpasswd secret" do
  command "htpasswd -b -c /etc/ganglia-webfrontend/htaccess #{node[:ganglia][:web][:user]} #{node[:ganglia][:web][:password]}"
end

template "/etc/ganglia-webfrontend/apache.conf" do
  source "apache.conf.erb"
  mode '0644'
  notifies :restart, resources(:service => "apache2")
end

link "/etc/apache2/conf.d/ganglia-webfrontend" do
  case node[:platform]
  when "debian","ubuntu"
    target_file "/etc/apache2/conf.d/ganglia-webfrontend"
  when "centos","redhat","amazon","fedora","scientific","oracle"
    target_file "/etc/httpd/conf.d/ganglia-webfrontend.conf"
  end
  to "/etc/ganglia-webfrontend/apache.conf"
  notifies :restart, resources(:service => "apache2")
end

template "#{node[:apache][:document_root]}/index.html" do
  source "ganglia.index.html.erb"
  mode '0644'
end

include_recipe 'scalarium_ganglia::views'

execute "Restart gmetad if not running" do # can happen if ganglia role is shared?
  command "(sleep 60 && /etc/init.d/gmetad restart) &"
  not_if "pgrep gmetad"
end
