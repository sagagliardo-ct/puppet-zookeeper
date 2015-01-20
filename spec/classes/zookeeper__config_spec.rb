require 'spec_helper'

describe 'zookeeper::config' do
  let(:facts) { default_test_facts }

  it { should contain_file("/opt/boxen/config/zookeeper") }
  it { should contain_file("/opt/boxen/data/zookeeper") }
  it { should contain_file("/opt/boxen/log/zookeeper") }

  it { should contain_file("/opt/boxen/config/zookeeper/zoo.cfg") }
  it { should contain_file("/opt/boxen/config/zookeeper/log4j.properties") }

  it 'should generate content for zoo.cfg' do
    content = catalogue(:class).resource('file', '/opt/boxen/config/zookeeper/zoo.cfg').send(:parameters)[:content]
    content.should_not be_empty
  end
end
