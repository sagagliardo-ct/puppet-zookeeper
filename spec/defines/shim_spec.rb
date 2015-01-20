require 'spec_helper'

describe 'zookeeper::shim' do
  let(:facts) { default_test_facts }
  let(:title) { 'name' }

  it do
    should contain_file("/opt/boxen/homebrew/bin/#{title}").with(
      'mode'  => '0755',
      'owner' => 'testuser',
      'group' => 'staff'
    )
  end

end
