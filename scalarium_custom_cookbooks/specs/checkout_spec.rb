require 'minitest/spec'

describe_recipe 'scalarium_custom_cookbooks::checkout' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
