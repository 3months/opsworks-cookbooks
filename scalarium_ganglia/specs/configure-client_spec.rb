require 'minitest/spec'

describe_recipe 'scalarium_ganglia::configure-client' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
