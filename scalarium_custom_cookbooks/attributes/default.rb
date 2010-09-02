default[:scalarium_custom_cookbooks] = {}
default[:scalarium_custom_cookbooks][:enabled] = false
default[:scalarium_custom_cookbooks][:user] = 'root'
default[:scalarium_custom_cookbooks][:group] = 'root'
default[:scalarium_custom_cookbooks][:home] = '/root'
default[:scalarium_custom_cookbooks][:destination] = '/root/scalarium-agent/site-cookbooks'

default[:scalarium_custom_cookbooks][:recipes] = []

default[:scalarium_custom_cookbooks][:scm] = {}
default[:scalarium_custom_cookbooks][:scm][:type] = 'git'
default[:scalarium_custom_cookbooks][:scm][:user] = nil
default[:scalarium_custom_cookbooks][:scm][:password] = nil
default[:scalarium_custom_cookbooks][:scm][:ssh_key] = nil
default[:scalarium_custom_cookbooks][:scm][:repository] = nil

default[:scalarium_custom_cookbooks][:scm][:revision] = 'HEAD'
default[:scalarium_custom_cookbooks][:enable_submodules] = true