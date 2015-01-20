require "spec_helper"

describe "zookeeper::service" do
  let(:facts) { default_test_facts }
  let(:params) do
    {
      'ensure' => 'present',
      'enable' => true,
      'servicename' => 'dev.zookeeper'
    }
  end

    context "Darwin" do
      let(:facts) { default_test_facts.merge(:operatingsystem => "Darwin") }

      it do
        should contain_service("dev.zookeeper").with_alias('zookeeper')
      end
    end
  end
