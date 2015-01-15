require 'spec_helper'

describe 'zookeeper' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
      :boxen_user => 'testuser',
    }
  end

  it { should contain_class('homebrew') }
  it { should contain_class('boxen::config') }
  it { should contain_package('boxen/brews/zookeeper') }
  it { should contain_package('zookeeper') }

  it { should contain_file("/opt/boxen/config/zookeeper") }
  it { should contain_file("/opt/boxen/data/zookeeper") }
  it { should contain_file("/opt/boxen/log/zookeeper") }

  it { should contain_file("/opt/boxen/config/zookeeper/zoo.cfg") }
  it { should contain_file("/opt/boxen/config/zookeeper/defaults") }
  it { should contain_file("/opt/boxen/config/zookeeper/log4j.properties") }

  it { should contain_zookeeper__shim('zkServer') }
  it { should contain_zookeeper__shim('zkCli') }
  it { should contain_zookeeper__shim('zkCleanup') }

  it 'should generate content for zoo.cfg' do
    content = catalogue(:class).resource('file', '/opt/boxen/config/zookeeper/zoo.cfg').send(:parameters)[:content]
    content.should_not be_empty
  end

end
