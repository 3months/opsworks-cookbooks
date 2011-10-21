service "gmond" do
  supports :status => false, :restart => false
  start_command "gmond"
  stop_command "pkill gmond"
  restart_command "pkill gmond; (sleep 60 && gmond) &" #ignore error if not running and start with 60s delay so that the monitoring node has our hostname configured when we connect
  action :nothing
end

monitoring_master = node[:scalarium][:roles]['monitoring-master'][:instances].collect{|instance, names| names["private_dns_name"]}.first rescue nil

template "/etc/ganglia/gmond.conf" do
  source "gmond.conf.erb"
  variables({
    :cluster_name => node[:scalarium][:cluster][:name],
    :monitoring_master => monitoring_master
  })
  
  notifies :restart, resources(:service => "gmond")
  only_if do
    File.exists?("/etc/ganglia/gmond.conf")
  end
end

if monitoring_master.nil?
  execute "Stop gmond if there is no monitoring master" do
    command "pkill gmond"
    only_if "pgrep gmond"
  end
end


if node[:scalarium][:instance][:roles].any?{|role| ['rails-app', 'php-app'].include?(role) }
  Dir.glob("#{node[:apache][:log_dir]}/*ganglia*.log").each do |ganglia_log|
    cron "Ganglia Apache Monitoring #{ganglia_log}" do
      minute "*/2"
      command "/usr/sbin/ganglia-logtailer --classname ApacheLogtailer --log_file #{ganglia_log} --mode cron > /dev/null 2>&1"
    end
  end
end

instances = {}

node[:scalarium][:roles].each do |role_name, role_config|
  role_config[:instances].each do |instance_name, instance_config|
    instances[instance_name] ||= []
    instances[instance_name] << role_name
  end
end

instances.keys.each do |instance_name|
  template "#{node[:ganglia][:datadir]}/conf/host_#{instance_name}.json" do
    source 'host_view_json.erb'
    mode '0644'
    variables({:roles => instances[instance_name]})
  end
end
