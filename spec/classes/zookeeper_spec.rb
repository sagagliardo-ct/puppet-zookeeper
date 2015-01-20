require 'spec_helper'

describe 'zookeeper' do
  let(:facts) { default_test_facts }

  it do
    should contain_class('zookeeper::config')
    should contain_class('zookeeper::package')
    should contain_class('zookeeper::service')
  end
end
