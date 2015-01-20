require 'spec_helper'

describe 'zookeeper::package' do
  it do
    should contain_package('boxen/brews/zookeeper')

    should contain_file("/opt/boxen/config/zookeeper/defaults")

    should contain_zookeeper__shim('zkServer')
    should contain_zookeeper__shim('zkCli')
    should contain_zookeeper__shim('zkCleanup')
  end
end
