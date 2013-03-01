require 'spec_helper'

describe 'zookeeper::shim' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
      :luser => 'testuser',
    }
  end
  let(:title) { 'name' }

  it do
    should contain_file("/opt/boxen/homebrew/bin/#{title}").with(
      'mode'  => '0755',
      'owner' => 'testuser',
      'group' => 'staff'
    )
  end

end
