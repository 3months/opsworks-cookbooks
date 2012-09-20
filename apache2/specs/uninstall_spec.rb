require 'minitest/spec'

describe 'apache2::uninstall'
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'should stop apache2' do
    case node[:platform]
    when "debian","ubuntu"
      service("apache2").wont_be_running
    when "centos","redhat","amazon","fedora","scientific","oracle"
      service("httpd").wont_be_running
    else
      # Fail test if we don't have a supported OS.
      assert_equal(3, nil)
    end
  end

  it 'should remove the apache2 package' do
    case node[:platform]
    when "debian","ubuntu"
      package("apache2").wont_be_installed
    when "centos","redhat","amazon","fedora","scientific","oracle"
      package("httpd").wont_be_installed
    else
      # Fail test if we don't have a supported OS.
      assert_equal(3, nil)
    end
  end
end
