require 'minitest/spec'

describe_recipe 'mysql::percona_repository' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
