# test the memcached installation/service
require 'memcached'
include MiniTest::Chef::Assertions

class MemcacheTest < MiniTest::Chef::TestCase
 
  def test_exist_service_configuration_file
    file('/etc/default/memcached').must_exist
  end

  def test_exist_monit_configuration_file
    file('/etc/monit/conf.d/memcached.monitrc').must_exist
  end

  def test_service_started
    service("memcached").must_be_running
  end

  def access_memcache_over_tcp(host)
	port = "#{node[:memcached][:port]}"
	refute_equal nil,	
		     TCPSocket.new("#{host}", "#{port}"), 
		     "Memcached is not accepting connections on #{host}:#{port}"
  end

  def test_memcache_access_via_tcp_on_127_0_0_1
  	access_memcache_over_tcp('127.0.0.1')
  end

  def test_memcache_access_via_tcp_on_localhost
  	access_memcache_over_tcp('localhost')
  end

  def test_memcache_access_via_tcp_on_private_ip
  	access_memcache_over_tcp("#{node[:scalarium]['instance']['private_ip']}")
  end

  def access_memcached_service(host) 
    port = "#{node[:memcached][:port]}"

    m = Memcached.new(["#{host}:#{port}"],{:binary_protocol=>false})

    #test different types of data. Memcached has issues with utf8 characters.
    key1 = 'foo'
    key2 = 'bar'*2
    #key3 = '£∞'
    key3 = "223FF"
    value1 = 'abc'
    value2 = 'xyz'*3
    #value3 = '∞§¶•ª'*2
    value3 = 'ERR..'

    100.times do
      assert_equal nil , m.set(key1, value1), "STORED\r\n"
      assert_equal nil , m.set(key2, value2), "STORED\r\n"
      assert_equal nil , m.set(key3, value3), "STORED\r\n"
      assert_equal value1, m.get(key1)
      assert_equal value2, m.get(key2)
      assert_equal value3, m.get(key3)
      assert_equal nil , m.delete(key1), "DELETED\r\n"
      assert_equal nil , m.set(key1, value2), "STORED\r\n"
      assert_equal value2, m.get(key1)
      assert_equal nil, m.set(key2, value3), "STORED\r\n"
      assert_equal value3, m.get(key2)
      assert_equal nil, m.set(key3, value1), "STORED\r\n"
      assert_equal value1, m.get(key3)
    end
  end
 
  def test_access_service_on_127_0_0_1
    access_memcached_service('127.0.0.1')
  end
  
  def test_access_service_on_localhost
    access_memcached_service('localhost')
  end
  
  def test_access_service_on_private_ip
    access_memcached_service("#{node[:scalarium]['instance']['private_ip']}")
  end
end
