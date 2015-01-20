require 'spec_helper'

describe 'zookeeper' do
  let(:facts) { default_test_facts }

  it { should contain_class('zookeeper::config') }

  it { should contain_package('boxen/brews/zookeeper') }
  it { should contain_package('zookeeper') }

  it { should contain_file("/opt/boxen/config/zookeeper/defaults") }

  it { should contain_zookeeper__shim('zkServer') }
  it { should contain_zookeeper__shim('zkCli') }
  it { should contain_zookeeper__shim('zkCleanup') }
end
