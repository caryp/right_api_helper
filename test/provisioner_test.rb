require 'right_api_helper'
require 'yaml'

describe RightApiHelper::Provisioner do

  before(:all) do
    @user_secrets = YAML.load(File.read(File.join(ENV['HOME'], '.right_api_client', 'login.yml')))
    @config =  {
      :servertemplate => 328222001, # "Base ServerTemplate for Linux Alpha (v14.0.0)"
      :deployment_name => "CP: right_api_provision testbed -- deleteme!",
      :server_name => "CP: Test: API Provisioned Server",
      :cloud_name => "EC2 us-east-1"
    }
  end

  it "provisions a server" do
    puts "Provisioning server in '#{@user_secrets[:account_id]}' account..."

    right_api_client = RightApiHelper::Session.new.create_client_from_file("~/.right_api_client/login.yml")

    # initialize rightscale provisioner
    @rightscale =
      RightApiHelper::Provisioner.new(right_api_client)

    # provision a RightScale managed server from a ServerTemplate
    @rightscale.provision(@config[:server_name],
                          @config[:servertemplate],
                          @config[:cloud_name],
                          @config[:deployment_name],
                          @config[:server_inputs],
                          @config[:multi_cloud_image_name],
                          nil, # ssh_key_id not yet supported
                          ["default"]) # secgroup_id not yet supported

    @rightscale.wait_for_operational()
  end


end
